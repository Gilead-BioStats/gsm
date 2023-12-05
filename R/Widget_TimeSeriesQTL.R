#' Time Series QTL
#'
#' `r lifecycle::badge("experimental")`
#'
#' A Time Series graphic for qtl data
#'
#' @param qtl specific qtl to filter to
#' @param raw_results `data.frame` Typically `lStackedSnapshots$rpt_site_kri_details`
#' @param raw_workflow `data.frame` Typically
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
  elementId = NULL
) {


  results <- raw_results  %>%
    dplyr::mutate(gsm_analysis_date = .data$snapshot_date) %>%
    dplyr::select(
      "studyid" = "study_id",
      "workflowid" = "kri_id",
      "groupid" = "site_id",
      "numerator",
      "denominator",
      "metric" = "kri_value",
      "score" = "kri_score",
      "flag" = "flag_value",
      "gsm_analysis_date",
      "snapshot_date"
    ) %>%
    dplyr::filter(.data$workflowid == qtl)

  workflow <- raw_workflow %>%
    dplyr::mutate(selectedGroupIDs = selectedGroupIDs) %>%
    select(
      "workflowid" = "kri_id",
      "group" = "meta_group",
      "abbreviation" = "kri_acronym",
      "metric" = "kri_name",
      "numerator" = "meta_numerator",
      "denominator" = "meta_denominator",
      "outcome" = "meta_outcome",
      "model" = "meta_model",
      "score" = "meta_score",
      "data_inputs" = "meta_data_inputs",
      "data_filters" = "meta_data_filters",
      "gsm_analysis_date"
    ) %>%
    dplyr::filter(.data$workflowid == qtl)

  parameters <- raw_param %>%
    select(
      "workflowid" = "kri_id",
      "param",
      "index" = "index_n",
      "gsm_analysis_date",
      "snapshot_date",
      "studyid" = "study_id",
      "value" = "default_s"
    ) %>%
    dplyr::filter(.data$workflowid == qtl)

  analysis <- raw_analysis %>%
    select(
      "studyid" = "study_id",
      "workflowid" = "qtl_id",
      "param",
      "value" = "qtl_value",
      "gsm_analysis_date",
      "snapshot_date"
    ) %>%
    dplyr::filter(.data$workflowid == qtl)

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
