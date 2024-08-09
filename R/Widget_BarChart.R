#' Bar Chart Widget
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' A widget that generates a bar chart of group-level metric results, plotting groups on the x-axis
#' and the outcome (numerator, denominator, metric, or score) on the y-axis.
#'
#' @inheritParams shared-params
#' @param vThreshold `numeric` Threshold values.
#' @param strOutcome `character` Outcome variable. Default: 'Score'.
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
#' ## Make chart
#' Widget_BarChart(
#'   dfResults = reportingResults_filter,
#'   dfGroups = reportingGroups,
#'   lMetric = reportingMetrics_filter,
#'   vThreshold = reportingMetrics_filter$Threshold
#' )
#'
#' @export

Widget_BarChart <- function(
  dfResults,
  lMetric = list(), # TODO: coerce list to object instead of array with jsonlite::toJSON()
  dfGroups = NULL,
  vThreshold = NULL,
  strOutcome = "Score",
  bAddGroupSelect = TRUE,
  strShinyGroupSelectID = "GroupID",
  bDebug = FALSE
) {
  # Parse `vThreshold` from comma-delimited character string to numeric vector.
  if (!is.null(vThreshold)) {
    if (is.character(vThreshold)) {
      vThreshold <- strsplit(vThreshold, ",")[[1]] %>% as.numeric()
    }
  }

  # Disable threshold if outcome is not 'Score'.
  if (strOutcome != "Score") {
    vThreshold <- NULL
  }

  # define widget inputs
  input <- list(
    dfResults = dfResults,
    lMetric = lMetric,
    dfGroups = dfGroups,
    vThreshold = vThreshold,
    strOutcome = strOutcome,
    bAddGroupSelect = bAddGroupSelect,
    strShinyGroupSelectID = strShinyGroupSelectID,
    bDebug = bDebug
  )

  # create widget
  widget <- htmlwidgets::createWidget(
    name = "Widget_BarChart",
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

#' Shiny bindings for Widget_BarChart
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Output and render functions for using Widget_BarChart within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a Widget_BarChart
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
#' @export
renderWidget_BarChart <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  } # force quoted
  htmlwidgets::shinyRenderWidget(expr, Widget_BarChartOutput, env, quoted = TRUE)
}
