function (assessment, summary_table) {
    for (i in seq_along(assessment)) {
        kri_key <- names(assessment)[i]
        kri <- assessment[[kri_key]]
        title <- gsm::meta_workflow %>% filter(.data$workflowid == 
            kri_key) %>% pull(.data$metric)
        print(htmltools::h3(title))
        cat("#### Summary Charts {.tabset} \n")
        charts <- assessment[[i]]$lResults$lCharts[names(assessment[[i]]$lResults$lCharts) %in% 
            c("scatterJS", "barMetricJS", "barScoreJS", "timeSeriesContinuousJS")]
        for (j in seq_along(charts)) {
            chart_key <- names(charts)[j]
            chart <- charts[[chart_key]]
            chart_name <- switch(chart_key, scatterJS = "Scatter Plot", 
                barScoreJS = "Bar Chart (KRI Score)", barMetricJS = "Bar Chart (KRI Metric)", 
                timeSeriesContinuousJS = "Time Series (Continuous)")
            chart_header <- paste("#####", chart_name, "\n")
            cat(chart_header)
            purrr::map(charts, ~.x %>% knitr::knit_print() %>% 
                attr("knit_meta") %>% knitr::knit_meta_add() %>% 
                invisible())
            cat(paste0("<div class =", chart_key, ">"))
            cat(knitr::knit_print(htmltools::tagList(chart)))
            cat("</div>")
        }
        cat("#### {-} \n")
        if (!is.null(summary_table[[assessment[[i]]$name]])) {
            print(htmltools::h4("Summary Table"))
            print(htmltools::tagList(summary_table[[assessment[[i]]$name]]))
        }
    }
}
