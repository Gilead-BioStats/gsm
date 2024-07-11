#' Scatter Plot Widget
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
#' A widget that generates a scatter plot of group-level metric results, plotting the denominator
#' on the x-axis and the numerator on the y-axis.
#'
#' @param dfSummary `data.frame` Output of [gsm::Summarize()].
#' @param lMetric `list` Metric metadata, captured at the top of metric workflows and returned by
#' [gsm::MakeMetricInfo()].
#' @param dfGroups `data.frame` Group metadata.
#' @param dfBounds `data.frame` Output of [gsm::Analyze_NormalApprox_PredictBounds()] or
#' [gsm::Analyze_Poisson_PredictBounds()]
#' @param bAddGroupSelect `logical` Add a dropdown to highlight sites? Default: `TRUE`.
#' @param bDebug `logical` Print debug messages? Default: `FALSE`.
#'
#' @examples
#' \dontrun{
#' lWorkflows <- MakeWorkflowList()
#' strMetricID <- 'kri0001'
#' lMetricWorkflow <- lWorkflows[[ strMetricID ]]
#' lMetricWorkflow$meta$GroupLevel <- 'Site'
#' 
#' lData <- list(
#'     dfEnrolled = clindata::rawplus_dm %>% filter(enrollyn == 'Y'),
#'     dfAE = clindata::rawplus_ae
#' )
#' 
#' lResults <- RunWorkflow(
#'     lMetricWorkflow,
#'     lData
#' )
#' 
#' dfGroups <- bind_rows(
#'     "SELECT site_num as GroupID, site_status as Status, pi_first_name as InvestigatorFirstName, pi_last_name as InvestigatorLastName, city as City, state as State, country as Country, * FROM df" %>%
#'         RunQuery(clindata::ctms_site) %>%
#'         MakeLongMeta('Site'),
#'     "SELECT siteid as GroupID, COUNT(DISTINCT subjectid) as ParticipantCount, COUNT(DISTINCT siteid) as SiteCount FROM df GROUP BY siteid" %>%
#'         RunQuery(lData$dfEnrolled) %>%
#'         MakeLongMeta('Site')
#' )
#' 
#' Widget_ScatterPlot(
#'     dfSummary = lResults$dfSummary,
#'     lMetric = lMetricWorkflow$meta,
#'     dfGroups = dfGroups,
#'     dfBounds = lResults$dfBounds
#' )
#' }
#' @export

Widget_ScatterPlot <- function(
  dfSummary,
  lMetric = list(),
  dfGroups = NULL,
  dfBounds = NULL,
  bAddGroupSelect = TRUE,
  bDebug = FALSE
) {
  # define widget inputs
  input <- list(
    dfSummary = dfSummary,
    lMetric = lMetric,
    dfGroups = dfGroups,
    dfBounds = dfBounds,
    bAddGroupSelect = bAddGroupSelect,
    bDebug = bDebug
  )

  # create widget
  widget <- htmlwidgets::createWidget(
    name = "Widget_ScatterPlot",
    purrr::map(
      input,
      ~ jsonlite::toJSON(
          .x,
          null = "null",
          na = "string",
          auto_unbox = TRUE
      )
    ),
    package = "gsm"
  )

  if (bDebug) {
    viewer <- getOption('viewer')
    options(viewer = NULL)
    print(widget)
    options(viewer = viewer)
  }

  return(widget)
}

#' Shiny bindings for Widget_ScatterPlot
#'
#' `r lifecycle::badge("stable")`
#'
#' Output and render functions for using Widget_ScatterPlot within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a Widget_ScatterPlot
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name Widget_ScatterPlot-shiny
#'
#' @export
Widget_ScatterPlotOutput <- function(outputId, width = "100%", height = "400px") {
  htmlwidgets::shinyWidgetOutput(outputId, "Widget_ScatterPlot", width, height, package = "gsm")
}

#' @rdname Widget_ScatterPlot-shiny
#' @export
renderWidget_ScatterPlot <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  } # force quoted
  htmlwidgets::shinyRenderWidget(expr, Widget_ScatterPlotOutput, env, quoted = TRUE)
}
