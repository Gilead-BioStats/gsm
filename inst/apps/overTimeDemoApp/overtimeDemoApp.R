devtools::load_all()
library(shiny)

# Prep data --------------------------------------------------------------------
dfResults <- gsm::reportingResults %>%
  # Remove the first Snapshots because they're all NA-flagged.
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

# Shiny ui ---------------------------------------------------------------------
ui <- fluidPage(
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
              Widget_FlagOverTimeOutput("FlagOverTime")
            ),
            div(
              style = "overflow: auto;",
              shiny::div(
                style = "font-size: 20px; font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';",
                "Group Overview"
              ),
              Widget_GroupOverviewOutput("GroupOverview")
            )
          )
        ),
        tabPanel("Data", DT::dataTableOutput("results"))
      )
    )
  )
)

# Shiny server -----------------------------------------------------------------
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
  output$GroupOverview <- renderWidget_GroupOverview({
    Widget_GroupOverview(
      dfResults = rResults_Latest(),
      dfMetrics = rMetrics(),
      dfGroups = dfGroups,
      strGroupSubset = "all"
    )
  })

  # Widget_FlagOverTime
  output$FlagOverTime <- renderWidget_FlagOverTime(
    dfResults = rResults(),
    dfMetrics = rMetrics()
  )

  # Data
  output$results <- DT::renderDataTable({rResults()})
}

# Run the shiny app ------------------------------------------------------------
shinyApp(ui = ui, server = server, options = list(launch.browser = TRUE))
