#' Time Series QTL
#'
#' `r lifecycle::badge("experimental")`
#'
#' A Time Series graphic for qtl data
#'
#' @param qtl specific qtl to filter to
#' @param dfSummary `data.frame` Longitudinal data.
#' @param lLabels `list` Longitudinal workflow/metadata.
#' @param dfParams `data.frame` Longitudinal parameter/configuration data.
#' @param dfAnalysis `data.frame` Longitudinal QTL analysis results.
#' @param selectedGroupIDs TODO
#' @param width the width of the widget
#' @param height the height of the widget
#' @param elementId id of widget, automatically generated if not supplied
#'
#'
#' @export
Widget_TimeSeriesQTL <- function(qtl,
  dfSummary,
  lLabels,
  dfParams,
  dfAnalysis,
  selectedGroupIDs = NULL,
  width = NULL,
  height = NULL,
  elementId = NULL
) {
  # results -----------------------------------------------------------------
  results <- dfSummary %>%
    dplyr::mutate(
      gsm_analysis_date = .data$snapshot_date
    ) %>%
    dplyr::select(
      "studyid",
      "metricid",
      "groupid" = "siteid",
      "numerator" = "numerator_value",
      "denominator" = "denominator_value",
      "metric" = "metric_value",
      "score",
      "flag" = "flag_value",
      "gsm_analysis_date",
      "snapshot_date"
    ) %>%
    dplyr::filter(.data$metricid == qtl) %>%
    jsonlite::toJSON()



  # workflow ----------------------------------------------------------------
  if (!is.null(selectedGroupIDs)) {
    lLabels[["selectedGroupIDs"]] <- selectedGroupIDs
  } else {
    lLabels[["selectedGroupIDs"]] <- "None"
  }

  workflow <- jsonlite::toJSON(lLabels)

  # params ------------------------------------------------------------------
  # {
  #   "workflowid": "qtl0004",
  #   "param": "strGroup",
  #   "index": null,
  #   "gsm_analysis_date": "2023-12-19",
  #   "snapshot_date": "2023-12-19",
  #   "studyid": "AA-AA-000-0000",
  #   "value": "Study",
  #   "groupid": ""
  # }

  parameters <- dfParams %>%
    dplyr::filter(.data$metricid == qtl) %>%
    mutate(
      value = .data$default_s,
      groupid = ""
    ) %>%
    select(
      "workflowid",
      "param",
      "index",
      "gsm_analysis_date",
      "snapshot_date",
      "studyid",
      "value",
      "groupid"
    ) %>%
    jsonlite::toJSON()




  # analysis ----------------------------------------------------------------

  # {
  #   "studyid": "AA-AA-000-0000",
  #   "workflowid": "qtl0006",
  #   "param": "LowCI",
  #   "value": "0",
  #   "gsm_analysis_date": "2003-12-01",
  #   "snapshot_date": "2003-12-01"
  # }
  #
  analysis <- dfAnalysis %>%
    dplyr::filter(.data$workflowid == qtl) %>%
    select(
      "studyid",
      "metricid",
      "param",
      "value",
      "gsm_analysis_date",
      "snapshot_date"
    ) %>%
    jsonlite::toJSON()

  # widget ------------------------------------------------------------------
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

#' Shiny bindings for timeSeriesQTL
#'
#' `r lifecycle::badge("experimental")`
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


#' @rdname timeSeriesQTL-shiny
#' @export
renderWidget_TimeSeriesQTL <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  } # force quoted
  htmlwidgets::shinyRenderWidget(expr, Widget_TimeSeriesQTLOutput, env, quoted = TRUE)
}
