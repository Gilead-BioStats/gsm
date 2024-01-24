function (results, workflow, bounds, selectedGroupIDs = NULL, 
    addSiteSelect = TRUE, width = NULL, height = NULL, elementId = NULL, 
    siteSelectLabelValue = NULL) {
    results <- results %>% dplyr::rename_with(tolower)
    if (!is.null(bounds)) {
        bounds <- bounds %>% dplyr::rename_with(tolower)
    }
    if (!is.null(elementId)) {
        elementId <- paste(elementId, as.numeric(Sys.time()) * 
            1000, sep = "-")
    }
    if (!is.null(siteSelectLabelValue)) {
        siteSelectLabelValue <- paste0("Highlighted ", siteSelectLabelValue, 
            ": ")
    }
    x <- list(results = results, workflow = workflow, bounds = bounds, 
        selectedGroupIDs = as.character(selectedGroupIDs), addSiteSelect = addSiteSelect, 
        siteSelectLabelValue = siteSelectLabelValue)
    htmlwidgets::createWidget(name = "Widget_ScatterPlot", x, 
        width = width, height = height, package = "gsm", elementId = elementId)
}
