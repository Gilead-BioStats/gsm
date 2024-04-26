#' Render charts for a given metric to markdown
#'
#' This function generates a markdown framework for charts
#
#' @param lCharts A list of charts for the selected metric.
#'
#' @return Markdown content with charts and a summary table for the metric
#'
#' @export
#' 
Report_MetricCharts <- function(lCharts) {

    #### charts tabset
    cat("#### Summary Charts {.tabset} \n")
    chartTypes<-c("scatterJS", "barMetricJS", "barScoreJS", "timeSeriesContinuousScoreJS", "timeSeriesContinuousMetricJS", "timeSeriesContinuousNumeratorJS", "timeseriesQtl")
    lCharts <- lCharts[names(lCharts) %in% chartTypes]
    for (j in seq_along(lCharts)) {
        chart_key <- names(lCharts)[j]
        chart <- lCharts[[j]]

        chart_name <- switch(chart_key,
            scatterJS = paste0(fontawesome::fa("arrow-up-right-dots", fill = "#337ab7"), "  Summary"),
            barScoreJS = paste0(fontawesome::fa("chart-simple", fill = "#337ab7"), "  KRI Score"),
            barMetricJS = paste0(fontawesome::fa("chart-simple", fill = "#337ab7"), "  KRI Metric"),
            timeSeriesContinuousScoreJS = paste0(fontawesome::fa("chart-line", fill = "#337ab7"), "  KRI Score"),
            timeSeriesContinuousMetricJS = paste0(fontawesome::fa("chart-line", fill = "#337ab7") ,"  KRI Metric"),
            timeSeriesContinuousNumeratorJS = paste0(fontawesome::fa("chart-line", fill = "#337ab7"), "  Numerator")
        )

        ##### chart tab /
        chart_header <- paste("#####", chart_name, "\n")

        cat(chart_header)

        # need to initialize JS dependencies within loop in order to print correctly
        # see here: https://github.com/rstudio/rmarkdown/issues/1877#issuecomment-678996452
        purrr::map(
        lCharts,
        ~ .x %>%
            knitr::knit_print() %>%
            attr("knit_meta") %>%
            knitr::knit_meta_add() %>%
            invisible()
        )

        # Display chart.
        cat(paste0("<div class =", chart_key, ">"))
        cat(knitr::knit_print(htmltools::tagList(chart)))
        cat("</div>")
        ##### / chart tab
    }

    cat("#### {-} \n")
    #### / charts tabset
}