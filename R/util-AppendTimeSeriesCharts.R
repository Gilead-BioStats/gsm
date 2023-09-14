AppendTimeSeriesCharts <- function(lAssessment) {


  lSnapshot$lStudyAssessResults <- lSnapshot$lStudyAssessResults %>%
    purrr::imap(function(result, workflowid) {
      this_workflow_id <- workflowid

      siteSelectLabelValue <- lSnapshot$lSnapshot$meta_workflow %>%
        filter(.data$workflowid == this_workflow_id) %>%
        pull(.data$group)

      result$lResults$lData$dfSummaryLongitudinal <- stackedSnapshots$results_summary %>%
        dplyr::filter(
          .data$workflowid == !!workflowid
        )

      workflow <- stackedSnapshots$meta_workflow %>%
        dplyr::filter(
          .data$workflowid == !!workflowid
        )

      parameters <- stackedSnapshots$parameters %>%
        dplyr::filter(
          .data$workflowid == !!workflowid
        )

      result$lResults$lCharts[["timeSeriesContinuousJS"]] <- Widget_TimeSeries(
        results = result$lResults$lData$dfSummaryLongitudinal,
        workflow = workflow,
        parameters = parameters,
        siteSelectLabelValue = siteSelectLabelValue
      )

      return(result)
    })


}


