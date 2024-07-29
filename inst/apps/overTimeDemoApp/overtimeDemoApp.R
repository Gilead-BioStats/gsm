# This is a Shiny app to demonstrate an experimental new feature.

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
  titlePanel("Flag Over Time Demo"),
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
      ),
      actionButton("reset", "Reset"),
      width = 2
    ),
    mainPanel(
      width = 10,
      tabsetPanel(
        tabPanel(
          "Charts",
          shiny::column(
            width = 6,
            uiOutput("GroupOverview")
          ),
                    shiny::column(
            width = 6,
            # Widget_FlagOverTimeOutput("FlagOverTime")
            uiOutput("FlagOverTime")
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
  output$GroupOverview <- renderUI({
    Widget_GroupOverview(
      dfResults = rResults_Latest(),
      dfMetrics = rMetrics(),
      dfGroups = dfGroups,
      strGroupSubset = "all"
    )
  })

  # Widget_FlagOverTime
  # output$FlagOverTime <- renderWidget_FlagOverTime(
  #   dfResults = rResults(),
  #   dfMetrics = rMetrics()
  # )
  output$FlagOverTime <- renderUI({
    Widget_FlagOverTime(
      dfResults = rResults(),
      dfMetrics = rMetrics()
    )
  })

  # Data
  output$results <- DT::renderDataTable({rResults()})

  # Reset button
  observeEvent(input$reset, {
    updateSelectInput(
      session,
      "GroupID",
      selected = unique(dfResults$GroupID)
    )
    updateSelectInput(
      session,
      "MetricID",
      selected = unique(dfResults$MetricID)
    )
    updateSelectInput(
      session,
      "Dates",
      selected = unique(dfResults$SnapshotDate)
    )
  })

  # Update selectInputs based on click events
  # Re-enable when callBacks are added for Widget_GroupOverview (shiny version)
  #
  # observeEvent(input$GroupOverviewGroupID, {
  #   updateSelectInput(
  #     session,
  #     "GroupID",
  #     selected = input$GroupOverviewGroupID
  #   )
  # })
  #
  # observeEvent(input$GroupOverviewMetricID, {
  #   updateSelectInput(
  #     session,
  #     "MetricID",
  #     selected = input$GroupOverviewMetricID
  #   )
  # })
}

# Run the shiny app ------------------------------------------------------------
shinyApp(ui = ui, server = server, options = list(launch.browser = TRUE))
