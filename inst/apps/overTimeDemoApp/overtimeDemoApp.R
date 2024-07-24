devtools::load_all()
library(shiny)
# TODO
# - Improve layout
# - Build the flag over time widget and deploy here (#1664)
# - Run this with data that includes all KRIs (#1703)

# Load data
dfResults <- gsm::reportingResults %>%
  dplyr::filter(SnapshotDate != "2012-01-31") %>%
  dplyr::mutate(
    # Fast-forward the dates so we span 2 years.
    SnapshotDate = .data$SnapshotDate %>%
      lubridate::ymd() %>%
      lubridate::rollforward(roll_to_first = TRUE) %>%
      lubridate::rollforward(roll_to_first = TRUE) %>%
      lubridate::rollforward(roll_to_first = TRUE) %>%
      lubridate::rollforward(roll_to_first = TRUE) %>%
      lubridate::rollforward(roll_to_first = TRUE) %>%
      lubridate::rollforward(roll_to_first = TRUE) %>%
      lubridate::rollforward()
  )
dfMetrics <- gsm::reportingMetrics
dfGroups <- gsm::reportingGroups

# Make a basic shiny app framework
ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      .gt_table {
        margin-left: 0 !important;
      }
    "))
  ),
  titlePanel("KRI Dashboard"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "GroupID",
        "Group",
        unique(dfResults$GroupID),
        selected = unique(dfResults$GroupID),
        multiple = TRUE,
        selectize = FALSE
      ),
      selectInput(
        "MetricID",
        "Metric",
        unique(dfResults$MetricID),
        selected = unique(dfResults$MetricID),
        multiple = TRUE,
        selectize = FALSE
      ),
      selectInput(
        "Dates",
        "Dates",
        unique(dfResults$SnapshotDate),
        selected = unique(dfResults$SnapshotDate),
        multiple = TRUE,
        selectize = FALSE
      )
    ),
    mainPanel(
      tabsetPanel(
        tabPanel(
          "Charts",
          div(
            div(
              style = "overflow: auto; max-height: 400px; margin-bottom: 15px;",
              gt::gt_output("FlagOverTime")
            ),
            div(
              style = "overflow: auto;",
              shiny::div(
                style = "font-size: 20px; font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';",
                "Group Overview"
              ),
              uiOutput("GroupOverview")
            )
          )
        ),
        tabPanel("Data", DT::dataTableOutput("results"))
      )
    )
  )
)

server <- function(input, output, session) {
  rMetrics <- reactive({
    dfMetrics %>% dplyr::filter(MetricID %in% input$MetricID)
  })
  rResults <- reactive({
    dfResults %>%
      dplyr::filter(GroupID %in% input$GroupID) %>%
      dplyr::filter(MetricID %in% input$MetricID) %>%
      dplyr::filter(SnapshotDate %in% input$Dates)
  })
  rResults_Latest <- reactive({
    rResults() %>%
      dplyr::filter(SnapshotDate == max(SnapshotDate))
  })

  # Widget_GroupOverview
  output$GroupOverview <- renderUI({
    Widget_GroupOverview(
      dfResults = rResults_Latest(),
      dfMetrics = rMetrics(),
      dfGroups = dfGroups,
      strGroupSubset = "all"
    )
  })

  # Report_FlagOverTime
  output$FlagOverTime <- gt::render_gt({
    Report_FlagOverTime(
      dfResults = rResults(),
      dfMetrics = rMetrics()
    )
  }, align = "left")

  # Data
  output$results <- DT::renderDataTable({rResults()})
}

# Run the shiny app
options(vsc.viewer = FALSE)

shinyApp(ui = ui, server = server, options = list(launch.browser = TRUE))
