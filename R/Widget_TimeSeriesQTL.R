function(
    qtl, raw_results, raw_workflow, raw_param, raw_analysis,
    selectedGroupIDs = NULL, width = NULL, height = NULL, elementId = NULL) {
  results <- raw_results %>%
    dplyr::filter(.data$workflowid ==
      qtl) %>%
    dplyr::mutate(snapshot_date = .data$gsm_analysis_date)
  workflow <- raw_workflow %>%
    dplyr::filter(.data$workflowid ==
      qtl) %>%
    dplyr::mutate(selectedGroupIDs = selectedGroupIDs)
  parameters <- raw_param %>%
    dplyr::filter(.data$workflowid ==
      qtl) %>%
    mutate(snapshot_date = .data$gsm_analysis_date)
  analysis <- raw_analysis
  if (is.null(selectedGroupIDs)) {
    selectedGroupIDs <- "None"
  }
  x <- list(
    results = results, workflow = workflow, parameters = parameters,
    analysis = analysis, selectedGroupIDs = c(as.character(selectedGroupIDs))
  )
  htmlwidgets::createWidget(
    name = "Widget_TimeSeriesQTL",
    x, width = width, height = height, package = "gsm", elementId = elementId
  )
}
