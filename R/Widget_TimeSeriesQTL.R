#' `r lifecycle::badge("experimental")`
#'
#' Time Series QTL
#'
#' A Time Series graphic for qtl data
#'
#' @param qtl specific qtl to filter to
#' @param raw_results TODO
#' @param raw_workflow TODO
#' @param raw_param TODO
#' @param raw_analysis TODO
#' @param selectedGroupIDs TODO
#' @param width the width of the widget
#' @param height the height of the widget
#' @param elementId id of widget, automatically generated if not supplied
#'
#' @import htmlwidgets
#'
#' @export
Widget_TimeSeriesQTL <- function(qtl,
  raw_results,
  raw_workflow,
  raw_param,
  raw_analysis,
  selectedGroupIDs = NULL,
  width = NULL,
  height = NULL,
  elementId = NULL) {
  results <- raw_results %>%
    dplyr::filter(.data$workflowid == qtl) %>%
    mutate(snapshot_date = .data$gsm_analysis_date) # contains the string qtl

  workflow <- raw_workflow %>%
    dplyr::filter(.data$workflowid == qtl) %>%
    dplyr::mutate(selectedGroupIDs = selectedGroupIDs)

  parameters <- raw_param %>%
    dplyr::filter(.data$workflowid == qtl) %>%
    mutate(
      value = NA,
      snapshot_date = .data$gsm_analysis_date
    )

  analysis <- raw_analysis # %>%
  #   dplyr::filter(grepl("qtl", .data$workflowid))

  if (is.null(selectedGroupIDs)) {
    selectedGroupIDs <- "None"
  }

  # forward options using x
  x <- list(
    results = results,
    workflow = workflow,
    parameters = parameters,
    analysis = analysis,
    selectedGroupIDs = c(as.character(selectedGroupIDs))
  )

  # create standalone timeseries widget
  htmlwidgets::createWidget(
    name = "Widget_TimeSeriesQTL",
    x,
    width = width,
    height = height,
    package = "gsm",
    elementId = elementId
  )
}

#' `r lifecycle::badge("experimental")`
#'
#' Shiny bindings for timeSeriesQTL
#'
#' Output and render functions for using timeSeriesQTL within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a timeSeriesQTL
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name timeSeriesQTL-shiny
#'
#' @export
Widget_TimeSeriesQTLOutput <- function(outputId, width = "100%", height = "400px") {
  htmlwidgets::shinyWidgetOutput(outputId, "Widget_TimeSeriesQTL", width, height, package = "gsm")
}

#' `r lifecycle::badge("experimental")`
#'
#' @rdname timeSeriesQTL-shiny
#' @export
renderWidget_TimeSeriesQTL <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  } # force quoted
  htmlwidgets::shinyRenderWidget(expr, Widget_TimeSeriesQTLOutput, env, quoted = TRUE)
}
