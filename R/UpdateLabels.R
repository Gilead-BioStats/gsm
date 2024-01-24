function (lStudyAssessResults, dfMetaWorkflow) {
    stopifnot(`[ lStudyAssessResults ] must be a list.` = is.list(lStudyAssessResults), 
        `[ dfMetaWorkflow ] must be a data.frame` = is.data.frame(dfMetaWorkflow))
    study <- lStudyAssessResults %>% purrr::map(~{
        workflowid <- .x$name
        js_charts <- .x$lResults$lCharts[grep("JS", names(.x$lResults$lCharts))]
        js_charts_updated <- purrr::map(js_charts, ~{
            .x$x$workflow <- AssignLabelsJS(.x, workflowid, dfMetaWorkflow)
            return(.x)
        })
        .x$lResults$lCharts[grep("JS", names(.x$lResults$lCharts))] <- js_charts_updated
        ggplot2_charts <- .x$lResults$lCharts[!names(.x$lResults$lCharts) %in% 
            names(js_charts)]
        ggplot2_charts_updated <- purrr::map(ggplot2_charts, 
            ~{
                required_labels <- SubsetMetaWorkflow(dfMetaWorkflow, 
                  workflowid)
                .x$labels$y <- glue::glue("{required_labels$numerator} ({required_labels$outcome})")
                .x$labels$x <- glue::glue("{required_labels$group}: {required_labels$denominator}")
                .x$labels$title <- glue::glue("{required_labels$metric} by {required_labels$group}")
                .x$labels$subtitle <- glue::glue("Workflow: {required_labels$workflowid}")
                return(.x)
            })
        .x$lResults$lCharts[!names(.x$lResults$lCharts) %in% 
            names(js_charts)] <- ggplot2_charts_updated
        return(.x)
    })
}
