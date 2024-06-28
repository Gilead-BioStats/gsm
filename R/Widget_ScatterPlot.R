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
#' lDataRaw <- list(
#'     dfSTUDY = clindata::ctms_study,
#'     dfSITE = clindata::ctms_site,
#'     dfSUBJ = clindata::rawplus_dm,
#'     dfAE = clindata::rawplus_ae
#' )
#'
#' lMappingWorkflow <- MakeWorkflowList('mapping')$mapping
#'
#' lMappingWorkflow$steps <- lMappingWorkflow$steps %>%
#'     purrr::keep(~ .x$params$df %in% names(lDataRaw))
#'
#' lDataMapped <- RunWorkflow(
#'     lMappingWorkflow,
#'     lDataRaw
#' )$lData
#' 
#' strMetricID <- 'kri0001'
#' lMetricWorkflow <- MakeWorkflowList(strMetricID)[[ strMetricID ]]
#' 
#' lResults <- RunWorkflow(
#'     lMetricWorkflow,
#'     lDataMapped
#' )
#' 
#' dfGroups <- clindata::ctms_site %>%
#'     left_join(
#'         lDataMapped$dfEnrolled %>%
#'             group_by(siteid) %>%
#'             tally(name = 'enrolled_participants'),
#'         c('site_num' = 'siteid')
#'     ) %>%
#'     rename(
#'         SiteID = site_num,
#'         status = site_status
#'     )
#' 
#' Widget_ScatterPlot(
#'     dfSummary = lResults$lData$dfSummary,
#'     lMetric = lMetricWorkflow$meta,
#'     dfGroups = dfGroups,
#'     dfBounds = lResults$lData$dfBounds
#' )
#' }
#' @export

Widget_ScatterPlot <- function(
  dfSummary,
  lMetric,
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
