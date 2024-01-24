function(
    results = NULL, workflow = list(), threshold = NULL,
    yaxis = "score", selectedGroupIDs = NULL, addSiteSelect = TRUE,
    width = NULL, height = NULL, elementId = NULL, siteSelectLabelValue = NULL) {
  results <- results %>%
    dplyr::mutate(across(
      everything(),
      as.character
    )) %>%
    dplyr::rename_with(tolower)
  if (!is.null(elementId)) {
    elementId <- paste(elementId, as.numeric(Sys.time()) *
      1000, sep = "-")
  }
  if (!is.null(siteSelectLabelValue)) {
    siteSelectLabelValue <- paste0(
      "Highlighted ", siteSelectLabelValue,
      ": "
    )
  }
  x <- list(
    results = results, workflow = workflow, threshold = threshold,
    yaxis = yaxis, selectedGroupIDs = as.character(selectedGroupIDs),
    addSiteSelect = addSiteSelect, siteSelectLabelValue = siteSelectLabelValue
  )
  htmlwidgets::createWidget(
    name = "Widget_BarChart", x, width = width,
    height = height, package = "gsm", elementId = elementId
  )
}
