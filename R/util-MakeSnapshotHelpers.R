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
  if(!group %in% c("site", "kri")){
    stop("`group` argument must be either 'site' or 'kri'")
  }

  data <- CompileResultsSummary(lResults)

  if(group == "site"){
    grouping_variable <- "GroupID"
    cols_to_select <- c("siteid" = "GroupID", "num_of_at_risk_kris" = "amber", "num_of_flagged_kris" = "red")
  } else if(group == "kri") {
    grouping_variable <- "kri"
    cols_to_select <- c("kri_id" = "kri", "num_of_sites_at_risk" = "amber", "num_of_sites_flagged" = "red")
  }

  data %>%
    group_by(.data[[grouping_variable]], .data$flag_color) %>%
    summarise(n_flags = n(), .groups = "drop") %>%
    filter(.data$flag_color %in% c("red", "amber")) %>%
    tidyr::pivot_wider(names_from = "flag_color", values_from = "n_flags") %>%
    {if(!"amber" %in% names(.)) tibble::add_column(., "amber" = as.integer(NA)) else .} %>%
    {if(!"red" %in% names(.)) tibble::add_column(., "red" = as.integer(NA)) else .} %>%
    select(all_of(cols_to_select))
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
#' @param dfConfigParam `data.frame` Workflow configuration parameters.
#' @param gsm_analysis_date `date` Date that `{gsm}` snapshot was run.
#'
#' @import purrr
#' @importFrom cli cli_alert_warning
#' @export
MakeRptQtlDetails <- function(lResults, dfMetaWorkflow, dfConfigParam, gsm_analysis_date) {
  qtl_present <- any(grepl("qtl", names(lResults)))
  if(!qtl_present){
    cli::cli_alert_warning("lResults argument in `MakeRptQtlDetails()` didn't contain any QTL's, returning blank data frame.")
    qtl_results <- data.frame("study_id" = NA_character_,
                              "snapshot_date" = gsm_analysis_date,
                              "qtl_id" = NA_character_,
                              "qtl_name" = NA_character_,
                              "numerator_name" = NA_character_,
                              "denominator_name" = NA_character_,
                              "qtl_value" = as.double(NA),
                              "base_metric" = NA_character_,
                              "numerator_value" = as.double(NA),
                              "denominator_value" = as.double(NA),
                              "qtl_score" = as.double(NA),
                              "qtl_flag" = NA_integer_,
                              "threshold" = as.double(NA),
                              "abbreviation" = NA_character_,
                              "meta_outcome" = NA_character_,
                              "meta_model" = NA_character_,
                              "meta_score" = NA_character_,
                              "meta_data_inputs" = NA_character_,
                              "meta_data_filters" = NA_character_,
                              "meta_gsm_version" = NA_character_,
                              "meta_group" = NA_character_,
                              "pt_cycle_id" = NA_character_,
                              "pt_data_dt" = NA_character_)
  } else {
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
          pull(.data$value) %>%
          as.numeric()

        rpt_qtl_details <- dplyr::tibble(
          study_id = df_summary$lData$dfSummary$GroupID,
          snapshot_date = gsm_analysis_date,
          qtl_id = qtl_name,
          qtl_name = meta_workflow_for_this_qtl$metric,
          numerator_name = meta_workflow_for_this_qtl$numerator,
          denominator_name = meta_workflow_for_this_qtl$denominator,
          qtl_value = df_summary$lData$dfSummary$Metric,
          base_metric = paste0(numerator_name, " / ", denominator_name),
          numerator_value = df_summary$lData$dfSummary$Numerator,
          denominator_value = df_summary$lData$dfSummary$Denominator,
          qtl_score = df_summary$lData$dfSummary$Score,
          qtl_flag = as.integer(df_summary$lData$dfSummary$Flag),
          threshold = threshold_for_this_qtl,
          abbreviation = meta_workflow_for_this_qtl$abbreviation,
          meta_outcome = meta_workflow_for_this_qtl$outcome,
          meta_model = meta_workflow_for_this_qtl$model,
          meta_score = meta_workflow_for_this_qtl$score,
          meta_data_inputs = meta_workflow_for_this_qtl$data_inputs,
          meta_data_filters = meta_workflow_for_this_qtl$data_filters,
          meta_gsm_version = meta_workflow_for_this_qtl$gsm_version,
          meta_group = meta_workflow_for_this_qtl$group,
          pt_cycle_id = NA_character_,
          pt_data_dt = NA_character_
        )
      })
  }
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
  if(!"kri" %in% types){
    cli::cli_alert_warning("lResults argument in `MakeRptSiteDetails()` didn't contain any KRI's with site level results,
                           `num_of_at_risk_kris` and `num_of_flagged_kris` will not be representative of site")
  }
  status_site %>%
    left_join(results, by = "siteid", relationship = "many-to-many") %>%
    mutate(snapshot_date = gsm_analysis_date,
           region = "Other",
           planned_participants = NA_integer_,
           pt_cycle_id = NA_character_,
           pt_data_dt = NA_character_) %>%
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
    replace_na(replace = list("num_of_at_risk_kris" = as.integer(0), "num_of_flagged_kris" = as.integer(0)))
}


#' Create rpt_study_details output for `Make_Snapshot()`
#'
#' @param lResults `list` the output from `Study_Assess()`
#' @param status_study `data.frame` the output from `Study_Map_Raw()`
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
    num_of_sites_flagged <- as.integer(0)
  }
  if("kri" %in% types){
    num_of_sites_flagged <-  results %>% filter(!is.na(num_of_sites_flagged)) %>% nrow()
  }
  status_study %>%
    mutate(snapshot_date = gsm_analysis_date,
           num_of_sites_flagged = num_of_sites_flagged,
           enrolling_sites_with_flagged_kris = as.integer(0),
           study_age = ExtractStudyAge(.data$fpfv, .data$snapshot_date),
           pt_cycle_id = NA_character_,
           pt_data_dt = NA_character_) %>%
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


#' Create rpt_kri_detail output for `Make_Snapshot()`
#'
#' @param lResults `list` the output from `Study_Assess()`
#' @param status_site `data.frame` the output from `Site_Map_Raw()`
#' @param meta_workflow `string` the meta_workflow stated in lMeta argument of `Make_Snapshot()`
#' @param gsm_analysis_date `string` the gsm analysis date calculated in `Make_Snapshot()`
#'
#' @export
#'
#' @keywords internal
MakeRptKriDetails <- function(lResults, status_site, meta_workflow, gsm_analysis_date) {
  types <- unique(gsub("[[:digit:]]", "", names(lResults)))
  results <- ExtractFlags(lResults, group = "kri")
  if(!"kri" %in% types){
    cli::cli_alert_warning("lResults argument in `MakeRptKRIDetail()` didn't contain any KRI's with site level results, `num_of_sites_flagged` will be reported as zero")
    num_of_sites_flagged <- integer(0)
  }
  meta_workflow %>%
    left_join(results, by = c("workflowid" = "kri_id"), relationship = "many-to-many") %>%
    replace_na(replace = list("num_of_sites_at_risk" = 0, "num_of_sites_flagged" = 0)) %>%
    mutate(snapshot_date = gsm_analysis_date,
           study_id = unique(status_site$studyid),
           kri_description = paste(.data$numerator, .data$denominator, sep = " / "),
           base_metric = paste(.data$numerator, .data$denominator, sep = " / "),
           total_num_of_sites = n_distinct(status_site$siteid),
           num_of_sites_flagged = num_of_sites_flagged,
           pt_cycle_id = NA_character_,
           pt_data_dt = NA_character_) %>%
    select("study_id",
           "snapshot_date",
           "kri_id" = "workflowid",
           "kri_name" = "metric",
           "kri_acronym" = "abbreviation",
           "kri_description",
           "base_metric",
           "meta_numerator" = "numerator",
           "meta_denominator" = "denominator",
           "num_of_sites_at_risk",
           "num_of_sites_flagged",
           "meta_outcome" = "outcome",
           "meta_model" = "model",
           "meta_score" = "score",
           "meta_data_inputs" = "data_inputs",
           "meta_data_filters" = "data_filters",
           "meta_gsm_version" = "gsm_version",
           "meta_group" = "group",
           "total_num_of_sites",
           "pt_cycle_id",
           "pt_data_dt"
    )
}


#' Create rpt_kri_site_detail output for `Make_Snapshot()`
#'
#' @param lResults `list` the output from `Study_Assess()`
#' @param status_site `data.frame` the output from `Site_Map_Raw()`
#' @param meta_workflow `string` the meta_workflow stated in lMeta argument of `Make_Snapshot()`
#' @param meta_param `string` the meta_param stated in lMeta argument of `Make_Snapshot()`
#' @param gsm_analysis_date `string` the gsm analysis date calculated in `Make_Snapshot()`
#'
#' @export
#'
#' @keywords internal
MakeRptSiteKriDetails <- function(lResults, status_site, meta_workflow, meta_param = NULL, gsm_analysis_date) {
  if(is.null(meta_param)){
    meta_param <- gsm::meta_param
  }
  thresholds <- meta_param %>%
    filter(.data$param == "vThreshold") %>%
    tidyr::pivot_wider(names_from = "index", values_from = "default") %>%
    select("kri" = "workflowid",
           "bottom_lower_threshold" = "1",
           "lower_threshold" = "2",
           "upper_threshold" = "3",
           "top_upper_threshold" = "4") %>%
    mutate(across("bottom_lower_threshold":"top_upper_threshold", as.double))

  CompileResultsSummary(lResults) %>%
    left_join(meta_workflow, by = c("kri" = "workflowid"), relationship = "many-to-many") %>%
    left_join(thresholds, by = "kri", relationship = "many-to-many") %>%
    left_join(status_site, by = c("GroupID" = "siteid"), relationship = "many-to-many") %>%
    mutate("study_id" = unique(status_site$studyid),
           "snapshot_date" = gsm_analysis_date,
           "no_of_consecutive_loads" = as.integer(NA),
           "country_aggregate" = as.double(NA),
           "study_aggregate" = as.double(NA),
           "pt_cycle_id" = NA_character_,
           "pt_data_dt" = NA_character_
    ) %>%
    select("study_id",
           "snapshot_date",
           "site_id" = "GroupID",
           "kri_id" = "kri",
           "kri_value" = "Metric",
           "kri_score" = "Score",
           "numerator" = "Numerator",
           "denominator" = "Denominator",
           "flag_value" = "Flag",
           "no_of_consecutive_loads",
           "upper_threshold",
           "lower_threshold",
           "bottom_lower_threshold",
           "top_upper_threshold",
           "kri_name" = "metric",
           "country_aggregate",
           "study_aggregate",
           "meta_numerator" = "numerator",
           "meta_denominator" = "denominator",
           "pt_cycle_id",
           "pt_data_dt"
    ) %>%
    mutate(across(c("flag_value", "no_of_consecutive_loads"), as.integer))
}

#' Create rpt_kri_bounds_details output for `Make_Snapshot()`
#'
#' @param lResults `list` the output from `Study_Assess()`
#' @param config_workflow `data.frame` configuration workflow in lMeta argument of `Make_Snapshot()`
#' @param gsm_analysis_date `string` Date of snapshot
#'
#' @export
#'
#' @keywords internal
MakeRptKriBoundsDetails <- function(lResults, config_workflow, gsm_analysis_date){
  bounds <- MakeResultsBounds(lResults = lResults, dfConfigWorkflow = config_workflow)
  if(length(bounds) > 0) {
    bounds %>%
    mutate("snapshot_date" = gsm_analysis_date,
           "pt_cycle_id" = NA_character_,
           "pt_data_dt" = NA_character_
    ) %>%
    select("study_id" = "studyid",
           "snapshot_date",
           "kri_id" = "workflowid",
           "threshold",
           "numerator",
           "denominator",
           "log_denominator",
           "pt_cycle_id",
           "pt_data_dt"
    )
  } else {
    cli::cli_alert_warning("lResults argument in `MakeRptKRIBoundsDetails` contains no bounds results for `qtl` only reports, returning blank data frame")
    data.frame("study_id" = NA_character_,
               "snapshot_date" = gsm_analysis_date,
               "kri_id" = NA_character_,
               "threshold" = as.double(NA),
               "numerator" = as.double(NA),
               "denominator" = as.double(NA),
               "log_denominator" = as.double(NA),
               "pt_cycle_id" = NA_character_,
               "pt_data_dt" = NA_character_)
  }
}

#' Create rpt_qtl_threshold_param output for `Make_Snapshot()`
#'
#' @param meta_param `data.frame` the meta_param defined in lMeta argument of `Make_Snapshot()` Default: gsm::meta_param
#' @param status_param `data.frame` the config_param defined in lMeta argument of `Make_Snapshot()`
#' @param gsm_analysis_date `string` Date of snapshot
#' @param type `string` type of threshold to output
#' @param verbose `logical` whether or not to display function messages
#'
#' @export
#'
#' @keywords internal
MakeRptThresholdParam <- function(meta_param, status_param, gsm_analysis_date, type, verbose = FALSE){
  if(!type %in% c("kri", "qtl")){
    stop("`type` must be either 'kri' or 'qtl'")
  }
  if( is.null(meta_param) & is.null(status_param) ) {
    if(verbose) {cli::cli_alert_warning("No `meta_param` or `status_param` found, returning blank data frame.")}
    data.frame("study_id" = NA_character_,
               "snapshot_date" = gsm_analysis_date,
               "workflowid" = NA_character_,
               "gsm_version" = NA_character_,
               "param" = NA_character_,
               "index_n" = NA_integer_,
               "default_s" = NA_character_,
               "configurable" = NA,
               "pt_cycle_id" = NA_character_,
               "pt_data_dt" = NA_character_) %>%
      rename_at("workflowid", ~paste0(type, "_id"))
  }
  if( is.null(meta_param) & !is.null(status_param) ) {
    if(verbose) {cli::cli_alert_warning("`MakeRptQTLThresholdParam()` is missing meta_param, status_param will be used to define defaults")}
    status_param %>%
      filter(grepl(type, .data$workflowid)) %>%
      mutate("snapshot_date" = gsm_analysis_date,
             "configurable" = NA,
             "pt_cycle_id" = NA_character_,
             "pt_data_dt" = NA_character_) %>%
      select("study_id" = "studyid",
             "snapshot_date",
             "workflowid",
             "gsm_version",
             "param",
             "index_n" = "index",
             "default_s" = "value",
             "configurable",
             "pt_cycle_id",
             "pt_data_dt")%>%
      rename_at("workflowid", ~paste0(type, "_id"))
  } else if( is.null(status_param) & !is.null(meta_param) ) {
    if(verbose) {cli::cli_alert_warning("`MakeRptQTLThresholdParam()` is missing status_param, meta_param will be used to define defaults")}
    meta_param %>%
      filter(grepl(type, .data$workflowid)) %>%
      mutate("study_id" = NA_character_,
             "snapshot_date" = gsm_analysis_date,
             "pt_cycle_id" = NA_character_,
             "pt_data_dt" = NA_character_) %>%
      select("study_id",
             "snapshot_date",
             "workflowid",
             "gsm_version",
             "param",
             "index_n" = "index",
             "default_s" = "default",
             "configurable",
             "pt_cycle_id",
             "pt_data_dt")%>%
      rename_at("workflowid", ~paste0(type, "_id"))
  } else {
  meta_param %>%
    filter(grepl(type, .data$workflowid)) %>%
    left_join(status_param, by = c("workflowid", "gsm_version", "param", "index"), relationship = "many-to-many") %>%
    mutate("default_s" = case_when(is.na(index) | (!is.na(index) & is.na(value)) ~ default,
                                   !is.na(index) & !is.na(value) ~ value),
           "study_id" = unique(status_param$studyid),
           "snapshot_date" = gsm_analysis_date,
           "pt_cycle_id" = NA_character_,
           "pt_data_dt" = NA_character_) %>%
    select("study_id",
           "snapshot_date",
           "workflowid",
           "gsm_version",
           "param",
           "index_n" = "index",
           "default_s",
           "configurable",
           "pt_cycle_id",
           "pt_data_dt")%>%
    rename_at("workflowid", ~paste0(type, "_id"))
  }
}

#' Create rpt_qtl_analysis output for `Make_Snapshot()`
#'
#' @param lResults `list` the output from `Study_Assess()`
#' @param status_param `data.frame` configuration parameters defined in lMeta argument of `Make_Snapshot()`
#' @param gsm_analysis_date `string` Date of snapshot
#'
#' @importFrom purrr map_df
#'
#' @export
#'
#' @keywords internal
MakeRptQtlAnalysis <- function(lResults, status_param, gsm_analysis_date){
  types <- unique(gsub("[[:digit:]]", "", names(lResults)))
  if(!"qtl" %in% types){
    cli::cli_alert_warning("lResults argument in `MakeRptQtlAnalysis` is missing qtl workflows, a blank data frame will be returned")
    output <- data.frame("study_id" = NA_character_,
                         "snapshot_date"= as.Date(NA),
                         "qtl_id" = NA_character_,
                         "param" = NA_character_,
                         "qtl_value" = as.double(NA),
                         "pt_cycle_id" = NA_character_,
                         "pt_data_dt" = NA_character_)
  } else {
    analysis <- purrr::map_df(lResults[grepl("qtl", names(lResults))], function(qtl){
      qtl$lResults$lData$dfAnalyzed
    }, .id = "qtl_id")

    output <- analysis %>%
      left_join(status_param, by = c("qtl_id" = "workflowid"), relationship = "many-to-many") %>%
      mutate("snapshot_date" = gsm_analysis_date,
             "pt_cycle_id" = NA_character_,
             "pt_data_dt" = NA_character_) %>%
      select("study_id" = "GroupID",
             "snapshot_date",
             "qtl_id",
             "param",
             "qtl_value" = "Score",
             "pt_cycle_id",
             "pt_data_dt")
  }

  return(output)
}


