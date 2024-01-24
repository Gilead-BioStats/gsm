function (results, workflow, parameters, selectedGroupIDs = NULL, 
    width = NULL, height = NULL, elementId = NULL, addSiteSelect = TRUE, 
    siteSelectLabelValue = NULL) {
    if (all(grepl("^[0-9]$", results$groupid))) {
        uniqueSiteSelections <- sort(unique(as.numeric(results$groupid)))
    }
    else {
        uniqueSiteSelections <- sort(unique(results$groupid))
    }
    if (!is.null(siteSelectLabelValue)) {
        siteSelectLabelValue <- paste0("Highlighted ", siteSelectLabelValue, 
            ": ")
    }
    x <- list(results = results, workflow = workflow, parameters = parameters, 
        addSiteSelect = addSiteSelect, selectedGroupIDs = c(as.character(selectedGroupIDs)))
    htmlwidgets::createWidget(name = "Widget_TimeSeries", x, 
        width = width, height = height, package = "gsm", elementId = elementId) %>% 
        htmlwidgets::prependContent(htmltools::tags$div(class = "select-group-container", 
            htmltools::tags$label(siteSelectLabelValue), htmltools::tags$select(class = "site-select--time-series", 
                id = glue::glue("site-select--time-series_{unique(workflow$workflowid)}"), 
                purrr::map(c("None", uniqueSiteSelections), ~htmltools::HTML(paste0("<option value='", 
                  .x, "'", ifelse(.x == selectedGroupIDs, "selected", 
                    ""), ">", .x, "</option>"))))))
}
