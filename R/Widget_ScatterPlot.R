#' Scatter Plot Widget
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' A widget that generates a scatter plot of group-level metric results, plotting the denominator
#' on the x-axis and the numerator on the y-axis.
#'
#' @inheritParams shared-params
#' @param bAddGroupSelect `logical` Add a dropdown to highlight sites? Default: `TRUE`.
#' @param strShinyGroupSelectID `character` Element ID of group select in Shiny context. Default: `'GroupID'`.
#'
#' @examples
#' ## Filter data to one metric and snapshot
#' reportingResults_filter <- reportingResults %>%
#'   dplyr::filter(MetricID == "kri0001" & SnapshotDate == max(SnapshotDate))
#'
#' reportingMetrics_filter <- reportingMetrics %>%
#'   dplyr::filter(MetricID == "kri0001") %>%
#'   as.list()
#'
#' reportingBounds_filter <- reportingBounds %>%
#'   dplyr::filter(MetricID == "kri0001" & SnapshotDate == max(SnapshotDate))
#'
#' Widget_ScatterPlot(
#'   dfResults = reportingResults_filter,
#'   lMetric = reportingMetrics_filter,
#'   dfGroups = reportingGroups,
#'   dfBounds = reportingBounds_filter
#' )
#'
#' @export

Widget_ScatterPlot <- function(
  dfResults,
  lMetric = list(), # TODO: coerce list to object instead of array with jsonlite::toJSON()
  dfGroups = NULL,
  dfBounds = NULL,
  bAddGroupSelect = TRUE,
  strShinyGroupSelectID = "GroupID",
  bDebug = FALSE
) {
  stopifnot(
    "dfResults is not a data.frame" = is.data.frame(dfResults),
    "lMetric must be a list, but not a data.frame" = is.list(lMetric) && !is.data.frame(lMetric),
    "dfGroups is not a data.frame" = is.null(dfGroups) || is.data.frame(dfGroups),
    "dfBounds is not a data.frame" = is.null(dfBounds) || is.data.frame(dfBounds),
    "bAddGroupSelect is not a logical" = is.logical(bAddGroupSelect),
    "strShinyGroupSelectID is not a character" = is.character(strShinyGroupSelectID),
    "bDebug is not a logical" = is.logical(bDebug)
  )
  # define widget inputs
  input <- list(
    dfResults = dfResults,
    lMetric = lMetric,
    dfGroups = dfGroups,
    dfBounds = dfBounds,
    bAddGroupSelect = bAddGroupSelect,
    strShinyGroupSelectID = strShinyGroupSelectID,
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
    viewer <- getOption("viewer")
    options(viewer = NULL)
    print(widget)
    options(viewer = viewer)
  }

  return(widget)
}

#' Shiny bindings for Widget_ScatterPlot
#'
#' @description
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
