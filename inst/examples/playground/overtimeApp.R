devtools::load_all()
library(shiny)

# Make a basic shiny app framework
ui <- fluidPage(
  titlePanel("KRI Dashboard"),
  sidebarLayout(
    sidebarPanel(
      selectInput("GroupID", "Group", NULL, multiple=TRUE, selectize = FALSE),
      selectInput("MetricID", "Metric", NULL, multiple=TRUE, selectize = FALSE)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel(
            "Charts",
            div(
                htmltools::div(
                    style = "table-layout: fixed; width: 100%; overflow: auto; display: inline-block;",
                    uiOutput("GroupOverview")
                ),
                htmltools::div(
                    style = "table-layout: fixed; width: 100%; overflow: auto; display: inline-block;",
                    uiOutput("FlagOverTime")
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

    rResults <- reactive({
    results<-dfResults %>%
        dplyr::filter(GroupID %in% input$GroupID) %>%
        dplyr::filter(MetricID %in% input$MetricID)
        print(dim(results))
        return(results)
    })

    # Widget_GroupOverview
    output$GroupOverview <- renderUI({
        gsm::Widget_GroupOverview(
            dfResults = rResults(),
            dfMetrics = dfMetrics,
            dfGroups = dfGroups,
            strGroupSubset = "all"
        )
    })

    # resize GroupOverview div based on the size of the content
    observe({
        js <- "Shiny.setInputValue('GroupOverviewHeight', document.getElementById('GroupOverview').scrollHeight);"
        session$sendCustomMessage(type = "jsCode", message = js)
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
