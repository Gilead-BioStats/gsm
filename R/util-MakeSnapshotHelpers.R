#' Create Study Results table for Report
#'
#' @param lResults `list` the output of `Study_Assess()` containing results of kri analysis
#'
#' @export
#'
#' @keywords internal
Flags_by_site <- function(lResults){
  output <- lResults[grep("kri", names(lResults))] %>%
    map_df(., function(kri) {
      bind_rows(kri$lResults$lData$dfSummary)
    }, .id = "kri") %>%
    filter(!is.na(Flag)) %>%
    mutate(flag_color = case_when(Flag %in% c(2, -2) ~ "red",
                                  Flag %in% c(1, -1) ~ "amber",
                                  Flag == 0 ~ "green")) %>%
    group_by(GroupID, flag_color) %>%
    summarise(n_flags = n(), .groups = "drop") %>%
    filter(flag_color %in% c("red", "amber")) %>%
    tidyr::pivot_wider(names_from = "flag_color", values_from = "n_flags") %>%
    select("siteid" = "GroupID",
           "num_of_at_risk_kris" = "red",
           "num_of_flagged_kris" = "amber")

  return(output)
}


#' Create Study Results table for Report
#'
#' @param fpfv `date` the date of the first patient visit of the study
#' @param snapshot_date `date` the date of the snapshot to derive the period of time from the fpfv
#'
#' @importFrom lubridate as.period
#' @importFrom lubridate interval
#' @importFrom stringr str_replace
#'
#' @export
#'
#' @keywords internal
ExtractStudyAge <- function(fpfv, snapshot_date) {
  raw_span <- lubridate::as.period(lubridate::interval(fpfv, snapshot_date), unit = "years")
  output <- raw_span %>%
    str_extract(".+d") %>%
    stringr::str_replace(pattern = "y", replacement = " years ") %>%
    stringr::str_replace(pattern = "m", replacement = " months ") %>%
    stringr::str_replace(pattern = "d", replacement = " days")
}


#' Make QTL Details Table
#'
#' @param lResults `list` List returned from [gsm::Study_Assess()].
#' @param dfMetaWorkflow `data.frame` Workflow metadata. See [gsm::meta_workflow].
#' @param gsm_analysis_date `date` Date that `{gsm}` snapshot was run.
#'
#' @import purrr
#'
#' @export
MakeRptQtlDetails <- function(lResults, dfMetaWorkflow, dfConfigParam, gsm_analysis_date) {

qtl_results <- lResults %>%
  purrr::keep_at(substring(names(.), 1, 3) == 'qtl') %>%
  purrr::map(~ .x[["lResults"]]) %>%
  purrr::discard(~ is.null(.x)) %>%
  purrr::discard(~ .x$lChecks$status == FALSE) %>%
  purrr::imap_dfr(function(df_summary, qtl_name) {

    meta_workflow_for_this_qtl <- dfMetaWorkflow %>%
      filter(
        .data$workflowid == qtl_name
      )

    # TODO: check if this logic is correct
    threshold_for_this_qtl <- dfConfigParam %>%
      filter(
        .data$workflowid == qtl_name & .data$param == "vThreshold"
      ) %>%
      pull(.data$value)

    rpt_qtl_details <- dplyr::tibble(
      study_id = df_summary$GroupID,
      snapshot_date = gsm_analysis_date,
      qtl_id = qtl_name,
      qtl_name = qtl_name,
      numerator_name = meta_workflow_for_this_qtl$numerator,
      denominator_name = meta_workflow_for_this_qtl$denominator,
      qtl_value = df_summary$Metric,
      base_metric = paste0(numerator_name, " / ", denominator_name),
      numerator_value = df_summary$Numerator,
      denominator_value = df_summary$Denominator,
      qtl_score = df_summary$Score,
      qtl_flag = df_summary$Flag,
      threshold = threshold_for_this_qtl,
      abbreviation = meta_workflow_for_this_qtl$abbreviation,
      meta_outcome = meta_workflow_for_this_qtl$outcome,
      meta_model = meta_workflow_for_this_qtl$model,
      meta_score = meta_workflow_for_this_qtl$score,
      meta_data_inputs = meta_workflow_for_this_qtl$data_inputs,
      meta_data_filters = meta_workflow_for_this_qtl$data_filters,
      meta_group = meta_workflow_for_this_qtl$group,
      pt_cycle_id = NA_character_,
      pt_data_dt = NA_character_
    )
  })


return(qtl_results)

}
