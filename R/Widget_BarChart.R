#' `r lifecycle::badge("stable")`
#'
#' KRI Bar Chart
#'
#' @description
#' A widget that displays a group-level bar chart based on the output of a KRI analysis.
#' Bar charts are provided by default in any Assess function, and are suffixed with "JS" to indicate that they are an `htmlwidget` ported from the `rbm-viz` JavaScript library.
#'
#' @param results data with column names:
#' \itemize{
#'  \item{\code{studyid}}
#'  \item{\code{workflowid}}
#'  \item{\code{groupid}}
#'  \item{\code{numerator}}
#'  \item{\code{denominator}}
#'  \item{\code{metric}}
#'  \item{\code{score}}
#'  \item{\code{flag}}
#' }
#'
#' @param workflow configuration data with columns:
#' \itemize{
#'  \item{\code{workflow}}
#'  \item{\code{gsm_version}}
#'  \item{\code{group}}
#'  \item{\code{metric}}
#'  \item{\code{numerator}}
#'  \item{\code{denominator}}
#'  \item{\code{outcome}}
#'  \item{\code{model}}
#'  \item{\code{score}}
#'  \item{\code{data_inputs}}
#'  \item{\code{data_filters}}
#' }
#'
#' @param threshold a one row data frame containing columns:
#' \itemize{
#'  \item{\code{workflowid}}
#'  \item{\code{gsm_version}}
#'  \item{\code{param}}
#'  \item{\code{index}}
#'  \item{\code{default}}
#'  \item{\code{configurable}}
#' }
#'
#' @param yaxis either \code{'score'} or \code{'metric'}
#' @param selectedGroupIDs group IDs to highlight, \code{NULL} by default, can be a single site or a vector.
#' @param addSiteSelect add a dropdown to highlight sites?
#' @param width width of widget, full screen by default
#' @param height height of widget, calculated based on width
#' @param elementId ID of container HTML element
#'
#' @import htmlwidgets
#'
#' @examples
#'
#' ae <- AE_Map_Raw()
#'
#' ae_transform <- Transform_Rate(
#'   dfInput = ae,
#'   strGroupCol = "SiteID",
#'   strNumeratorCol = "Count",
#'   strDenominatorCol = "Exposure"
#' )
#'
#' ae_analyze <- Analyze_NormalApprox(
#'   dfTransformed = ae_transform,
#'   strType = "rate"
#' )
#'
#' ae_flag <- Flag_NormalApprox(
#'   ae_analyze,
#'   vThreshold = c(-3, -2, 2, 3)
#' )
#'
#' ae_summary <- Summarize(
#'   ae_flag
#' )
#'
#' dfConfig <- MakeDfConfig(
#'   strMethod = "NormalApprox",
#'   strGroup = "Site",
#'   strAbbreviation = "AE",
#'   strMetric = "Adverse Event Rate",
#'   strNumerator = "Adverse Events",
#'   strDenominator = "Days on Study",
#'   vThreshold = c(-3, -2, 2, 3)
#' )
#'
#' plot <- Widget_BarChart(
#'   results = ae_summary,
#'   workflow = dfConfig,
#'   yaxis = "metric",
#'   elementId = "aeAssessMetric"
#' )
#'
#' @export
Widget_BarChart <- function(
  results = NULL,
  workflow = list(),
  threshold = NULL,
  yaxis = "score",
  selectedGroupIDs = NULL,
  addSiteSelect = TRUE,
  width = NULL,
  height = NULL,
  elementId = NULL
) {
  results <- results %>%
    dplyr::mutate(across(everything(), as.character)) %>%
    dplyr::rename_with(tolower)

  if (!is.null(elementId)) {
    elementId <- paste(elementId, as.numeric(Sys.time()) * 1000, sep = "-")
  }

  # forward options using x
  x <- list(
    results = results,
    workflow = workflow,
    threshold = threshold,
    yaxis = yaxis,
    selectedGroupIDs = as.character(selectedGroupIDs),
    addSiteSelect = addSiteSelect
  )

  # create widget
  htmlwidgets::createWidget(
    name = "Widget_BarChart",
    x,
    width = width,
    height = height,
    package = "gsm",
    elementId = elementId
  )
}

#' `r lifecycle::badge("stable")`
#'
#' Shiny bindings for Widget_BarChart
#'
#' Output and render functions for using barChart within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a barChart
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name Widget_BarChart-shiny
#'
#' @export
Widget_BarChartOutput <- function(outputId, width = "100%", height = "400px") {
  htmlwidgets::shinyWidgetOutput(outputId, "Widget_BarChart", width, height, package = "gsm")
}

#' @rdname Widget_BarChart-shiny
#'
#'
#' @export
renderWidget_BarChart <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  } # force quoted
  htmlwidgets::shinyRenderWidget(expr, Widget_BarChartOutput, env, quoted = TRUE)
}
