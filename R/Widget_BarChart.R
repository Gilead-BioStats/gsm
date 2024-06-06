#' KRI Bar Chart
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
#' A widget that displays a group-level bar chart based on the output of a KRI analysis.
#' Bar charts are provided by default in any Assess function, and are suffixed with "JS" to indicate that they are an `htmlwidget` ported from the `rbm-viz` JavaScript library.
#'
#' @param dfSummary data with column names:
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
#' @param lLabels configuration data with columns:
#' @param dfSite `data.frame` Site metadata.
#'
#' @param dfThreshold a one row data frame containing columns:
#' \itemize{
#'  \item{\code{workflowid}}
#'  \item{\code{gsm_version}}
#'  \item{\code{param}}
#'  \item{\code{index}}
#'  \item{\code{default}}
#'  \item{\code{configurable}}
#' }
#'
#' @param strYAxisType either \code{'score'} or \code{'metric'}
#' @param selectedGroupIDs group IDs to highlight, \code{NULL} by default, can be a single site or a vector.
#' @param addSiteSelect `logical` add a dropdown to highlight sites? Default: `TRUE`.
#' @param bHideDropdown `logical` should the dropdown be hidden? Default: `FALSE`. This is primarily used for the Shiny app `{gsmApp}` to hide the drop-down site selector,
#' since it is an additional element that needs to be updated based on user interactivity.
#' @param width width of widget, full screen by default
#' @param height height of widget, calculated based on width
#' @param elementId ID of container HTML element
#'
#'
#' @examples
#' ae_transform <- Transform_Rate(
#'   dfInput = sampleInput,
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
#' # labels list
#' lLabels <- list(
#'   workflowid = "",
#'   group = "Site",
#'   abbreviation = "AE",
#'   metric = "Adverse Event Rate",
#'   numerator = "Adverse Events",
#'   denominator = "Days on Study",
#'   model = "Normal Approximation",
#'   score = "Adjusted Z-Score"
#' )
#'
#' plot <- Widget_BarChart(
#'   dfSummary = ae_summary,
#'   lLabels = lLabels,
#'   strYAxisType = "metric",
#'   elementId = "aeAssessMetric"
#' )
#'
#' @export
Widget_BarChart <- function(
  dfSummary,
  lLabels,
  dfSite = NULL,
  dfThreshold = NULL,
  strYAxisType = "score",
  selectedGroupIDs = NULL,
  addSiteSelect = TRUE,
  bHideDropdown = FALSE,
  width = NULL,
  height = NULL,
  elementId = NULL
) {
  dfSummary <- dfSummary %>%
    dplyr::mutate(across(everything(), as.character)) %>%
    dplyr::rename_with(tolower)

  if (!is.null(elementId)) {
    elementId <- paste(elementId, as.numeric(Sys.time()) * 1000, sep = "-")
  }

  if (!is.null(lLabels$group)) {
    siteSelectLabelValue <- paste0("Highlighted ", lLabels$group, ": ")
  }

  if (!is.null(dfThreshold)) {
    dfThreshold <- jsonlite::toJSON(dfThreshold, na = "string")
  }

  if (!is.null(dfSite)) {
    dfSite <- jsonlite::toJSON(dfSite, na = "string")
  }

  # forward options using x
  x <- list(
    dfSummary = jsonlite::toJSON(dfSummary, na = "string"),
    lLabels = jsonlite::toJSON(lLabels, na = "string"),
    dfThreshold = dfThreshold,
    dfSite = dfSite,
    strYAxisType = strYAxisType,
    selectedGroupIDs = as.character(selectedGroupIDs),
    addSiteSelect = addSiteSelect,
    siteSelectLabelValue = siteSelectLabelValue,
    bHideDropdown = bHideDropdown
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

#' Shiny bindings for Widget_BarChart
#'
#' `r lifecycle::badge("stable")`
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
