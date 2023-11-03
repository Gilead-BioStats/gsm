#' Compile the results summary of all kri's in a snapshot
#'
#' @param lResults `list` the output of `Study_Assess()` containing results of kri analysis
#'
#' @import dplyr
#'
#' @export
#'
#' @keywords internal
CompileResultsSummary <- function(lResults){
  output <- lResults %>%
    purrr::map_df(., function(kri) {
      bind_rows(kri$lResults$lData$dfSummary)
    }, .id = "kri") %>%
    filter(!is.na(Flag)) %>%
    mutate(flag_color = case_when(Flag %in% c(2, -2) ~ "red",
                                  Flag %in% c(1, -1) ~ "amber",
                                  Flag == 0 ~ "green"))

  return(output)
}


#' Extract flag counts by site or KRI
#'
#' @param lResults `list` the output of `Study_Assess()` containing results of kri analysis
#' @param group `character` a character field to specify what to use to group flags by. options = "site", "kri"
#'
#' @import dplyr
#' @importFrom tidyr pivot_wider
#'
#' @export
#'
#' @keywords internal
ExtractFlags <- function(lResults, group){
  data <- CompileResultsSummary(lResults)
  if(!group %in% c("site", "kri")){
    stop("`group` argument must be either 'site' or 'kri'")
  }
  if(group == "site"){
    results <- filter(data, str_detect(kri, "kri"))
    if(nrow(results) == 0) {
      cli::cli_alert_warning("lResults argument in `ExtractFlags()` didn't contain any KRI's with site level results, unable to group by 'site'
                             Returning results for `kri` groups instead")
      results <- data
    }
  } else {
    results <- data
  }
  output <- results %>%
    {if(group == "site") {group_by(., GroupID, flag_color)} else .} %>%
    {if(group == "kri") {group_by(., kri, flag_color)} else .} %>%
    summarise(n_flags = n(), .groups = "drop") %>%
    filter(flag_color %in% c("red", "amber")) %>%
    tidyr::pivot_wider(names_from = "flag_color", values_from = "n_flags") %>%
    {if(!"amber" %in% names(.)) tibble::add_column(., "amber" = NA) else .} %>%
    {if(!"red" %in% names(.)) tibble::add_column(., "red" = NA) else .} %>%
    {if(group == "site") {select(.,"siteid" = "GroupID",
                                 "num_of_at_risk_kris" = "amber",
                                 "num_of_flagged_kris" = "red")}
      else .} %>%
    {if(group == "kri") {select(., "kri_id" = "kri",
                                "num_of_sites_at_risk" = "amber",
                                "num_of_sites_flagged" = "red")}
      else .}

  return(output)
}


#' Extract the study age from fpfv to the snapshot date
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


#' Create rpt_site_details output for `Make_Snapshot()`
#'
#' @param lResults `list` the output from `Study_Assess()`
#' @param status_site `data.frame` the output from `Site_Map_Raw()`
#' @param gsm_analysis_date `string` the gsm analysis date calculated in `Make_Snapshot()`
#'
#' @export
#'
#' @keywords internal
MakeRptSiteDetails <- function(lResults, status_site, gsm_analysis_date) {
  types <- unique(gsub("[[:digit:]]", "", names(lResults)))
  results <- ExtractFlags(lResults, group = "site")
  if(nrow(results) == 0){
    cli::cli_alert_warning("lResults argument in `MakeRptSiteDetails()` didn't contain any KRI's with site level results, returning blank data frame")
    output <- data.frame("study_id" = NA,
                         "snapshot_date" = NA,
                         "site_id" = NA,
                         "site_nm" = NA,
                         "site_status" = NA,
                         "investigator_nm" = NA,
                         "site_country" = NA,
                         "site_state" = NA,
                         "site_city" = NA,
                         "region" = NA,
                         "enrolled_participants" = NA,
                         "planned_participants" = NA,
                         "num_of_at_risk_kris" = NA,
                         "num_of_flagged_kris" = NA,
                         "pt_cycle_id" = NA,
                         "pt_data_dt" = NA)
  }
  if("kri" %in% types){
    output <- status_site %>%
      left_join(results, by = "siteid") %>%
      mutate(snapshot_date = gsm_analysis_date,
             region = "Other",
             planned_participants = as.numeric(NA),
             pt_cycle_id = as.character(NA),
             pt_data_dt = as.character(NA)) %>%
      select("study_id" = "studyid",
             "snapshot_date",
             "site_id" = "siteid",
             "site_nm" = "site_num",
             "site_status" = "status",
             "investigator_nm" = "invname",
             "site_country" = "country",
             "site_state" = "state",
             "site_city" = "city",
             "region",
             "enrolled_participants",
             "planned_participants",
             "num_of_at_risk_kris",
             "num_of_flagged_kris",
             "pt_cycle_id",
             "pt_data_dt"
      ) %>%
      replace_na(replace = list("num_of_at_risk_kris" = 0, "num_of_flagged_kris" = 0))
  }
  return(output)
}


#' Create rpt_study_details output for `Make_Snapshot()`
#'
#' @param lResults `list` the output from `Study_Assess()`
#' @param status_study `data.frame` the output from `Site_Map_Raw()`
#' @param gsm_analysis_date `string` the gsm analysis date calculated in `Make_Snapshot()`
#'
#' @export
#'
#' @keywords internal
MakeRptStudyDetails <- function(lResults, status_study, gsm_analysis_date) {
  types <- unique(gsub("[[:digit:]]", "", names(lResults)))
  results <- ExtractFlags(lResults, group = "kri")
  if(!"kri" %in% types){
    cli::cli_alert_warning("lResults argument in `MakeRptStudyDetails()` didn't contain any KRI's with site level results, `num_of_sites_flagged` will be reported as zero")
    num_of_sites_flagged <- 0
  }
  if("kri" %in% types){
    num_of_sites_flagged <-  results %>% filter(!is.na(num_of_sites_flagged)) %>% nrow()
  }
  status_study %>%
    mutate(snapshot_date = gsm_analysis_date,
           num_of_sites_flagged = num_of_sites_flagged,
           enrolling_sites_with_flagged_kris = 0,
           study_age = ExtractStudyAge(fpfv, snapshot_date),
           pt_cycle_id = as.character(NA),
           pt_data_dt = as.character(NA)) %>%
    select("study_id" = "studyid",
           "snapshot_date",
           "protocol_title" = "title",
           "therapeutic_area" = "ta",
           "indication",
           "phase",
           "product",
           "enrolled_sites",
           "enrolled_participants",
           "planned_sites",
           "planned_participants",
           "study_status" = "status",
           "fpfv",
           "lpfv",
           "lplv",
           "study_age",
           "num_of_sites_flagged",
           "enrolling_sites_with_flagged_kris",
           "pt_cycle_id",
           "pt_data_dt"
    )
}


