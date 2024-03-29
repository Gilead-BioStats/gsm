#' KRI Scatter Plot
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
#' A widget that displays a group-level scatter plot based on the output of a KRI analysis.
#' Scatter plots are provided by default in any Assess function, and are suffixed with "JS" to indicate that they are an `htmlwidget` ported from the `rbm-viz` JavaScript library.
#'
#' @param dfSummary data with columns:
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
#' @param lLabels configuration with columns:
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
#' @param dfBounds chart bounds data with columns:
#' \itemize{
#'  \item{\code{threshold}}
#'  \item{\code{numerator}}
#'  \item{\code{denominator}}
#'  \item{\code{metric}}
#'  \item{\code{logdenominator}}
#' }
#'
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
#' dfBounds <- Analyze_NormalApprox_PredictBounds(
#'   dfTransformed = ae_transform,
#'   vThreshold = c(-3, -2, 2, 3),
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
#' plot <- Widget_ScatterPlot(
#'   dfSummary = ae_summary,
#'   lLabels = lLabels,
#'   dfBounds = dfBounds,
#'   elementId = "aeAssessScatter"
#' )
#'
#' @export
Widget_ScatterPlot <- function(
  dfSummary,
  lLabels,
  dfBounds,
  selectedGroupIDs = NULL,
  addSiteSelect = TRUE,
  bHideDropdown = FALSE,
  width = NULL,
  height = NULL,
  elementId = NULL
) {
  dfSummary <- dfSummary %>%
    dplyr::rename_with(tolower)

  if (!is.null(dfBounds)) {
    dfBounds <- dfBounds %>%
      dplyr::rename_with(tolower) %>%
      jsonlite::toJSON()
  }

  if (!is.null(elementId)) {
    elementId <- paste(elementId, as.numeric(Sys.time()) * 1000, sep = "-")
  }

  if (!is.null(lLabels$group)) {
    siteSelectLabelValue <- paste0("Highlighted ", lLabels$group, ": ")
  }

  # forward options using x
  x <- list(
    dfSummary = jsonlite::toJSON(dfSummary, na = "string"),   # data
    lLabels = jsonlite::toJSON(lLabels, na = "string"),       # config
    dfBounds = dfBounds,                                      # bounds
    selectedGroupIDs = as.character(selectedGroupIDs),
    addSiteSelect = addSiteSelect,
    siteSelectLabelValue = siteSelectLabelValue,
    bHideDropdown = bHideDropdown
  )


  # create widget
  htmlwidgets::createWidget(
    name = "Widget_ScatterPlot",
    x,
    width = width,
    height = height,
    package = "gsm",
    elementId = elementId
  )
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
