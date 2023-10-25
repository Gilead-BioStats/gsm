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
  if(!group %in% c("site", "kri")){
    stop("`group` argument must be either 'site' or 'kri'")
  }
  if(group == "site"){
    lResults <- lResults[grep("kri", names(lResults))]
  }
  output <- lResults %>%
    map_df(., function(kri) {
      bind_rows(kri$lResults$lData$dfSummary)
    }, .id = "kri") %>%
    filter(!is.na(Flag)) %>%
    mutate(flag_color = case_when(Flag %in% c(2, -2) ~ "red",
                                  Flag %in% c(1, -1) ~ "amber",
                                  Flag == 0 ~ "green")) %>%
    {if(group == "site") {group_by(., GroupID, flag_color)} else .} %>%
    {if(group == "kri") {group_by(., kri, flag_color)} else .} %>%
    summarise(n_flags = n(), .groups = "drop") %>%
    filter(flag_color %in% c("red", "amber")) %>%
    tidyr::pivot_wider(names_from = "flag_color", values_from = "n_flags") %>%
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


#' Create rpt_site_details output for `Make_Snapshot()`
#'
#' @param lResults `list` the output from `Study_Assess()`
#' @param status_site `data.frame` the output from `Site_Map_Raw()`
#'
#' @export
#'
#' @keywords internal
MakeRptSiteDetails <- function(lResults, status_site) {
  status_site %>%
    left_join(ExtractFlags(lResults, group = "site"), by = "siteid") %>%
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


#' Create rpt_study_details output for `Make_Snapshot()`
#'
#' @param lResults `list` the output from `Study_Assess()`
#' @param status_study `data.frame` the output from `Site_Map_Raw()`
#'
#' @export
#'
#' @keywords internal
MakeRptStudyDetails <- function(lResults, status_study) {
  status_study %>%
    mutate(snapshot_date = gsm_analysis_date,
           num_of_sites_flagged = ExtractFlags(lResults, group = "site") %>% filter(!is.na(num_of_at_risk_kris)) %>% nrow(),
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

