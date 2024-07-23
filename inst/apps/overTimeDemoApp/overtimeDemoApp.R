devtools::load_all()
library(shiny)
# TODO
# - Improve layout
# - Filter the overview table to just the latest snapshot when rendering
# - Build the flag over time widget and deploy here (#1664)
# - Run this with data that includes all KRIs (#1703)



# Make a basic shiny app framework
ui <- fluidPage(
  titlePanel("KRI Dashboard"),
  sidebarLayout(
    sidebarPanel(
      selectInput("GroupID", "Group", NULL, multiple=TRUE, selectize = FALSE),
      selectInput("MetricID", "Metric", NULL, multiple=TRUE, selectize = FALSE),
      selectInput("Dates", "Dates",NULL, multiple=TRUE, selectize = FALSE)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel(
            "Charts",
            div(
                htmltools::div(
                    style = "table-layout: fixed; width: 100%; overflow: auto; display: inline-block; max-height: 300px;",
                    uiOutput("FlagOverTime")
                ),
                htmltools::div(
                    style = "table-layout: fixed; width: 100%; overflow: auto; display: inline-block;",
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
    dfResults <- gsm::reportingResults
    dfMetrics <- gsm::reportingMetrics %>% dplyr::filter(MetricID %in% unique(dfResults$MetricID)) 
    dfGroups <- gsm::reportingGroups

    # set the values for the selectInput
    updateSelectInput(session, "GroupID", choices = unique(dfResults$GroupID), selected = unique(dfResults$GroupID))
    updateSelectInput(session, "MetricID", choices = unique(dfResults$MetricID), selected = unique(dfResults$MetricID))
    updateSelectInput(session, "Dates", choices = unique(dfResults$SnapshotDate), selected = unique(dfResults$SnapshotDate))
    rMetrics <- reactive({dfMetrics %>% dplyr::filter(MetricID %in% input$MetricID)})
    rResults <- reactive({
    results<-dfResults %>%
        dplyr::filter(GroupID %in% input$GroupID) %>%
        dplyr::filter(MetricID %in% input$MetricID) %>% 
        dplyr::filter(SnapshotDate %in% input$Dates)
        print(dim(results))
        return(results)
    })

    # Widget_GroupOverview
    output$GroupOverview <- renderUI({
        gsm::Widget_GroupOverview(
            dfResults = rResults(),
            dfMetrics = rMetrics(),
            dfGroups = dfGroups,
            strGroupSubset = "all"
        )
    })

    # Report_FlagOverTime
    output$FlagOverTime <- renderUI({
        gsm::Report_FlagOverTime(
            dfResults = rResults(),
            dfMetrics = dfMetrics
        )
    })

    output$results <- DT::renderDataTable({rResults()})
}

# Run the shiny app
options(vsc.viewer = FALSE)

shinyApp(ui = ui, server = server, options = list(launch.browser = TRUE))
