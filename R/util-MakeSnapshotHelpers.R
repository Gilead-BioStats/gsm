#' Compile the results summary of all kri's in a snapshot
#'
#' @param lResults `list` the output of `Study_Assess()` containing results of kri analysis
#'
#' @import dplyr
#'
#' @export
#'
#' @keywords internal
CompileResultsSummary <- function(lResults) {
  output <- lResults %>%
    purrr::map_df(., function(kri) {
      bind_rows(kri$lResults$lData$dfSummary)
    }, .id = "workflowid") %>%
    filter(!is.na(Flag)) %>%
    mutate(flag_color = case_when(
      Flag %in% c(2, -2) ~ "red",
      Flag %in% c(1, -1) ~ "amber",
      Flag == 0 ~ "green"
    ))

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
ExtractFlags <- function(lResults, group) {
  if (!group %in% c("site", "kri")) {
    stop("`group` argument must be either 'site' or 'kri'")
  }

  data <- CompileResultsSummary(lResults)

  if (group == "site") {
    grouping_variable <- "GroupID"
    cols_to_select <- c("siteid" = "GroupID", "num_of_at_risk_kris" = "amber", "num_of_flagged_kris" = "red")
  } else if (group == "kri") {
    grouping_variable <- "workflowid"
    cols_to_select <- c("workflowid", "num_of_sites_at_risk" = "amber", "num_of_sites_flagged" = "red")
  }

  data %>%
    group_by(.data[[grouping_variable]], .data$flag_color) %>%
    summarise(n_flags = n(), .groups = "drop") %>%
    filter(.data$flag_color %in% c("red", "amber")) %>%
    tidyr::pivot_wider(names_from = "flag_color", values_from = "n_flags") %>%
    {
      if (!"amber" %in% names(.)) tibble::add_column(., "amber" = as.integer(NA)) else .
    } %>%
    {
      if (!"red" %in% names(.)) tibble::add_column(., "red" = as.integer(NA)) else .
    } %>%
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
#' @param gsm_analysis_date `date` Date that `{gsm}` snapshot was run. leave NULL if dealing with stacked results
#'
#' @import purrr
#' @importFrom cli cli_alert_warning
#' @export
MakeRptQtlDetails <- function(lResults, dfMetaWorkflow, dfConfigParam, gsm_analysis_date = NULL) {
  qtl_present <- any(grepl("qtl", names(lResults)))
  if (!qtl_present) {
    cli::cli_alert_warning("lResults argument in `MakeRptQtlDetails()` didn't contain any QTL's, returning blank data frame.")
    qtl_results <- data.frame(
      "studyid" = NA_character_,
      "snapshot_date" = {if(is.null(gsm_analysis_date)) "gsm_analysis_date" else gsm_analysis_date},
      "workflowid" = NA_character_,
      "metric" = NA_character_,
      "numerator_name" = NA_character_,
      "denominator_name" = NA_character_,
      "qtl_value" = as.double(NA),
      "base_metric" = NA_character_,
      "numerator_value" = as.double(NA),
      "denominator_value" = as.double(NA),
      "qtl_score" = as.double(NA),
      "flag" = NA_integer_,
      "threshold" = as.double(NA),
      "abbreviation" = NA_character_,
      "outcome" = NA_character_,
      "model" = NA_character_,
      "meta_score" = NA_character_,
      "data_inputs" = NA_character_,
      "data_filters" = NA_character_,
      "gsm_version" = NA_character_,
      "group" = NA_character_,
      "pt_cycle_id" = NA_character_,
      "pt_data_dt" = NA_character_
    )
  } else {
    qtl_results <- lResults %>%
      purrr::keep_at(substring(names(.), 1, 3) == "qtl") %>%
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
          studyid = df_summary$lData$dfSummary$GroupID,
          snapshot_date = gsm_analysis_date,
          workflowid = qtl_name,
          metric = meta_workflow_for_this_qtl$metric,
          numerator_name = meta_workflow_for_this_qtl$numerator,
          denominator_name = meta_workflow_for_this_qtl$denominator,
          qtl_value = df_summary$lData$dfSummary$Metric,
          base_metric = paste0(.data$numerator_name, " / ", .data$denominator_name),
          numerator_value = df_summary$lData$dfSummary$Numerator,
          denominator_value = df_summary$lData$dfSummary$Denominator,
          qtl_score = df_summary$lData$dfSummary$Score,
          flag = as.integer(df_summary$lData$dfSummary$Flag),
          threshold = threshold_for_this_qtl,
          abbreviation = meta_workflow_for_this_qtl$abbreviation,
          outcome = meta_workflow_for_this_qtl$outcome,
          model = meta_workflow_for_this_qtl$model,
          meta_score = meta_workflow_for_this_qtl$score,
          data_inputs = meta_workflow_for_this_qtl$data_inputs,
          data_filters = meta_workflow_for_this_qtl$data_filters,
          gsm_version = meta_workflow_for_this_qtl$gsm_version,
          group = meta_workflow_for_this_qtl$group,
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
#' @param gsm_analysis_date `string` the gsm analysis date calculated in `Make_Snapshot()`. leave NULL if dealing with stacked results
#'
#' @export
#'
#' @keywords internal
MakeRptSiteDetails <- function(lResults, status_site, gsm_analysis_date = NULL) {
  types <- unique(gsub("[[:digit:]]", "", names(lResults)))
  results <- ExtractFlags(lResults, group = "site")
  if (!"kri" %in% types) {
    cli::cli_alert_warning("lResults argument in `MakeRptSiteDetails()` didn't contain any KRI's with site level results,
                           `num_of_at_risk_kris` and `num_of_flagged_kris` will not be representative of site")
  }
  rpt_site_details <- status_site %>%
    left_join(results, by = "siteid", relationship = "many-to-many") %>%
    mutate(
      "snapshot_date" = {if(is.null(gsm_analysis_date)) "gsm_analysis_date" else gsm_analysis_date},
      "start_date" = as.Date(.data$start_date),
      "region" = "Other",
      "planned_participants" = NA_integer_,
      "pt_cycle_id" = NA_character_,
      "pt_data_dt" = NA_character_
    ) %>%
    replace_na(replace = list("num_of_at_risk_kris" = as.integer(0), "num_of_flagged_kris" = as.integer(0)))

  output <- RemapLog(rpt_site_details)

  return(output)
}


#' Create rpt_study_details output for `Make_Snapshot()`
#'
#' @param lResults `list` the output from `Study_Assess()`
#' @param status_study `data.frame` the output from `Study_Map_Raw()`
#' @param gsm_analysis_date `string` the gsm analysis date calculated in `Make_Snapshot()`. leave NULL if dealing with stacked results
#'
#' @export
#'
#' @keywords internal
MakeRptStudyDetails <- function(lResults, status_study, gsm_analysis_date = NULL) {
  types <- unique(gsub("[[:digit:]]", "", names(lResults)))
  results <- ExtractFlags(lResults, group = "kri")
  if (!"kri" %in% types) {
    cli::cli_alert_warning("lResults argument in `MakeRptStudyDetails()` didn't contain any KRI's with site level results, `num_of_sites_flagged` will be reported as zero")
    num_of_sites_flagged <- as.integer(0)
  }
  if ("kri" %in% types) {
    num_of_sites_flagged <- results %>%
      filter(!is.na(num_of_sites_flagged)) %>%
      nrow()
  }
  rpt_study_details <- status_study %>%
    mutate(
      "snapshot_date" = {if(is.null(gsm_analysis_date)) "gsm_analysis_date" else gsm_analysis_date},
      "num_of_sites_flagged" = num_of_sites_flagged,
      "enrolling_sites_with_flagged_kris" = as.integer(0),
      "study_age" = ExtractStudyAge(.data$fpfv, .data$snapshot_date),
      "pt_cycle_id" = NA_character_,
      "pt_data_dt" = NA_character_
    )

  output <- RemapLog(rpt_study_details)

  return(output)
}


#' Create rpt_kri_detail output for `Make_Snapshot()`
#'
#' @param lResults `list` the output from `Study_Assess()`
#' @param status_site `data.frame` the output from `Site_Map_Raw()`
#' @param meta_workflow `data.frame` the meta_workflow stated in lMeta argument of `Make_Snapshot()`
#' @param status_workflow `data.frame` the kri status workflow created with `MakeStatusWorkflow()`
#' @param gsm_analysis_date `string` the gsm analysis date calculated in `Make_Snapshot()`. leave NULL if dealing with stacked results
#'
#' @export
#'
#' @keywords internal
MakeRptKriDetails <- function(lResults, status_site, meta_workflow, status_workflow, gsm_analysis_date = NULL) {
  types <- unique(gsub("[[:digit:]]", "", names(lResults)))
  results <- ExtractFlags(lResults, group = "kri")
  if (!"kri" %in% types) {
    cli::cli_alert_warning("lResults argument in `MakeRptKRIDetail()` didn't contain any KRI's with site level results, `num_of_sites_flagged` will be reported as zero")
    num_of_sites_flagged <- integer(0)
  }

  rpt_kri_details <- meta_workflow %>%
    left_join(results, by = c("workflowid"), relationship = "many-to-many") %>%
    replace_na(replace = list("num_of_sites_at_risk" = 0, "num_of_sites_flagged" = 0)) %>%
    mutate(
      "snapshot_date" = {if(is.null(gsm_analysis_date)) "gsm_analysis_date" else gsm_analysis_date},
      "studyid" = unique(status_site$studyid),
      "kri_description" = paste(.data$numerator, .data$denominator, sep = " / "),
      "base_metric" = paste(.data$numerator, .data$denominator, sep = " / "),
      "total_num_of_sites" = n_distinct(status_site$siteid),
      "num_of_sites_flagged" = num_of_sites_flagged,
      "pt_cycle_id" = NA_character_,
      "pt_data_dt" = NA_character_
    ) %>%
    left_join(status_workflow, by = c("studyid", "workflowid", "gsm_version"))

  output <- RemapLog(rpt_kri_details)

  return(output)
}


#' Create rpt_kri_site_detail output for `Make_Snapshot()`
#'
#' @param lResults `list` the output from `Study_Assess()`
#' @param status_site `data.frame` the output from `Site_Map_Raw()`
#' @param meta_workflow `string` the meta_workflow stated in lMeta argument of `Make_Snapshot()`
#' @param meta_param `string` the meta_param stated in lMeta argument of `Make_Snapshot()`
#' @param gsm_analysis_date `string` the gsm analysis date calculated in `Make_Snapshot()`. leave NULL if dealing with stacked results
#'
#' @export
#'
#' @keywords internal
MakeRptSiteKriDetails <- function(lResults, status_site, meta_workflow, meta_param = NULL, gsm_analysis_date = NULL) {
  if (is.null(meta_param)) {
    meta_param <- gsm::meta_param
  }
  thresholds <- meta_param %>%
    filter(.data$param == "vThreshold") %>%
    tidyr::pivot_wider(names_from = "index", values_from = "default") %>%
    select(
      "workflowid",
      "bottom_lower_threshold" = "1",
      "lower_threshold" = "2",
      "upper_threshold" = "3",
      "top_upper_threshold" = "4"
    ) %>%
    mutate(across("bottom_lower_threshold":"top_upper_threshold", as.double))

  rpt_site_kri_details <- CompileResultsSummary(lResults) %>%
    left_join(meta_workflow, by = "workflowid", relationship = "many-to-one") %>%
    left_join(thresholds, by = "workflowid", relationship = "many-to-one") %>%
    left_join(status_site, by = c("GroupID" = "siteid"), relationship = "many-to-many") %>%
    mutate(
      "studyid" = unique(status_site$studyid),
      "snapshot_date" = {if(is.null(gsm_analysis_date)) "gsm_analysis_date" else gsm_analysis_date},
      "no_of_consecutive_loads" = as.integer(NA),
      "country_aggregate" = as.double(NA),
      "study_aggregate" = as.double(NA),
      "pt_cycle_id" = NA_character_,
      "pt_data_dt" = NA_character_
    )

    output <- RemapLog(rpt_site_kri_details) %>%
      mutate(across(c("flag_value", "no_of_consecutive_loads"), as.integer))

    return(output)
}

#' Create rpt_kri_bounds_details output for `Make_Snapshot()`
#'
#' @param lResults `list` the output from `Study_Assess()`
#' @param config_workflow `data.frame` configuration workflow in lMeta argument of `Make_Snapshot()`
#' @param gsm_analysis_date `string` Date of snapshot. leave NULL if dealing with stacked results
#'
#' @export
#'
#' @keywords internal
MakeRptKriBoundsDetails <- function(lResults, config_workflow, gsm_analysis_date = NULL) {
  bounds <- MakeResultsBounds(lResults = lResults, dfConfigWorkflow = config_workflow)
  if (length(bounds) > 0) {
    rpt_kri_bounds_details <- bounds %>%
      mutate(
        "snapshot_date" = {if(is.null(gsm_analysis_date)) "gsm_analysis_date" else gsm_analysis_date},
        "pt_cycle_id" = NA_character_,
        "pt_data_dt" = NA_character_
      )

    output <- RemapLog(rpt_kri_bounds_details)

  } else {
    cli::cli_alert_warning("lResults argument in `MakeRptKRIBoundsDetails` contains no bounds results for `qtl` only reports, returning blank data frame")
    output <- data.frame(
      "studyid" = NA_character_,
      "snapshot_date" = {if(is.null(gsm_analysis_date)) "gsm_analysis_date" else gsm_analysis_date},
      "workflowid" = NA_character_,
      "threshold" = as.double(NA),
      "numerator" = as.double(NA),
      "denominator" = as.double(NA),
      "log_denominator" = as.double(NA),
      "pt_cycle_id" = NA_character_,
      "pt_data_dt" = NA_character_
    )
  }
  return(output)
}

#' Create rpt_qtl_threshold_param output for `Make_Snapshot()`
#'
#' @param meta_param `data.frame` the meta_param defined in lMeta argument of `Make_Snapshot()` Default: gsm::meta_param
#' @param status_param `data.frame` the config_param defined in lMeta argument of `Make_Snapshot()`
#' @param gsm_analysis_date `string` Date of snapshot. leave NULL if dealing with stacked results
#' @param type `string` type of threshold to output
#' @param verbose `logical` whether or not to display function messages
#'
#' @export
#'
#' @keywords internal
MakeRptThresholdParam <- function(meta_param, status_param, gsm_analysis_date = NULL, type, verbose = FALSE) {
  if (!type %in% c("kri", "qtl")) {
    stop("`type` must be either 'kri' or 'qtl'")
  }

  if (type == "kri") {
    type <- "kri|cou"
  }

  if (is.null(meta_param) & is.null(status_param)) {
    if (verbose) {
      cli::cli_alert_warning("No `meta_param` or `status_param` found, returning blank data frame.")
    }
    output <- data.frame(
      "studyid" = NA_character_,
      "snapshot_date" = {if(is.null(gsm_analysis_date)) "gsm_analysis_date" else gsm_analysis_date},
      "workflowid" = NA_character_,
      "gsm_version" = NA_character_,
      "param" = NA_character_,
      "index" = NA_integer_,
      "default_s" = NA_character_,
      "configurable" = NA,
      "pt_cycle_id" = NA_character_,
      "pt_data_dt" = NA_character_
    )
  }
  if (is.null(meta_param) & !is.null(status_param)) {
    if (verbose) {
      cli::cli_alert_warning("`MakeRptQTLThresholdParam()` is missing meta_param, status_param will be used to define defaults")
    }

     table <- status_param %>%
      filter(grepl(type, .data$workflowid)) %>%
      mutate(
        "snapshot_date" = {if(is.null(gsm_analysis_date)) "gsm_analysis_date" else gsm_analysis_date},
        "default" = value,
        "configurable" = NA,
        "pt_cycle_id" = NA_character_,
        "pt_data_dt" = NA_character_
      )

     output <- RemapLog(table, table_name = paste0("rpt_", match.call()$type, "_threshold_param"))

  } else if (is.null(status_param) & !is.null(meta_param)) {
    if (verbose) {
      cli::cli_alert_warning("`MakeRptQTLThresholdParam()` is missing status_param, meta_param will be used to define defaults")
    }
    table <- meta_param %>%
      filter(grepl(type, .data$workflowid)) %>%
      mutate(
        "studyid" = NA_character_,
        "snapshot_date" = {if(is.null(gsm_analysis_date)) "gsm_analysis_date" else gsm_analysis_date},
        "pt_cycle_id" = NA_character_,
        "pt_data_dt" = NA_character_
      )

    output <- RemapLog(table, table_name = paste0("rpt_", match.call()$type, "_threshold_param"))
  } else {

    table <- meta_param %>%
      filter(grepl(type, .data$workflowid)) %>%
      left_join(status_param, by = c("workflowid", "gsm_version", "param", "index"), relationship = "many-to-many") %>%
      mutate(
        "snapshot_date" = gsm_analysis_date,
        "default_s" = case_when(
          is.na(index) | (!is.na(index) & is.na(value)) ~ default,
          !is.na(index) & !is.na(value) ~ value
        ),
        "studyid" = unique(status_param$studyid),
        "snapshot_date" = {if(is.null(gsm_analysis_date)) "gsm_analysis_date" else gsm_analysis_date},
        "pt_cycle_id" = NA_character_,
        "pt_data_dt" = NA_character_
      )
    output <- RemapLog(table, table_name = paste0("rpt_", match.call()$type, "_threshold_param"))
  }
  return(output)
}

#' Create rpt_qtl_analysis output for `Make_Snapshot()`
#'
#' @param lResults `list` the output from `Study_Assess()`
#' @param gsm_analysis_date `string` Date of snapshot
#'
#' @importFrom purrr map_df
#'
#' @export
#'
#' @keywords internal
MakeRptQtlAnalysis <- function(lResults, gsm_analysis_date) {
  types <- unique(gsub("[[:digit:]]", "", names(lResults)))
  if (!"qtl" %in% types) {
    cli::cli_alert_warning("lResults argument in `MakeRptQtlAnalysis` is missing qtl workflows, a blank data frame will be returned")
    output <- data.frame(
      "studyid" = NA_character_,
      "snapshot_date" = gsm_analysis_date,
      "workflowid" = NA_character_,
      "param" = NA_character_,
      "value" = as.double(NA),
      "pt_cycle_id" = NA_character_,
      "pt_data_dt" = NA_character_
    )
  } else {
    analysis <- MakeResultsAnalysis(lResults)

    rpt_qtl_analysis <- analysis %>%
      mutate(
        "snapshot_date" = {if(is.null(gsm_analysis_date)) "gsm_analysis_date" else gsm_analysis_date},
        "pt_cycle_id" = NA_character_,
        "pt_data_dt" = NA_character_
      )

    output <- RemapLog(rpt_qtl_analysis)
  }

  return(output)
}

#' Augment the previous lSnapshot classes to be inline with the current lSnapshot classes
#'
#' @param lPrevSnapshot `list` the previous Snapshot object
#' @param lSnapshot `list` the current Snapshot object
#'
#' @import dplyr
#' @importFrom purrr map_df
#'
#' @return Augmented previous snapshot object
#'
#' @export
#'
#' @keywords internal
Match_Class <- function(lPrevSnapshot, lSnapshot){
  if(is.null(lPrevSnapshot)){
    return(lSnapshot)
  } else {
    snapshot <- ifelse("lStackedSnapshots" %in% names(lPrevSnapshot), "lStackedSnapshots", "lSnapshot")
    prev_snapshot_classes <- purrr::map_df(lPrevSnapshot[[snapshot]], GetClass, .id = "file")
    curr_snapshot_classes <- purrr::map_df(lSnapshot, GetClass, .id = "file")

    unmatched_data_class <- left_join(prev_snapshot_classes, curr_snapshot_classes, by = c("file", "column"), relationship = "many-to-many") %>%
      filter(.data$class.x != .data$class.y)

    if (nrow(unmatched_data_class) > 0) {
      for(i in 1:nrow(unmatched_data_class)){
        File <- unmatched_data_class$file[i]

        lPrevSnapshot[[snapshot]][[File]] <- lPrevSnapshot[[snapshot]][[File]] %>%
          mutate(across(unmatched_data_class$column[i], get(paste0("as.", unmatched_data_class$class.y[i]))))
      }
    } else {
      return(lPrevSnapshot)
    }
  }
  return(lPrevSnapshot)
}


#' Appends the previous snapshot logs to the current snapshot logs
#'
#' @param lPrevSnapshot `list` the previous Snapshot object
#' @param lSnapshot `list` the current Snapshot object
#' @param files `vector` Optional vector of desired files to append, defaults to all files within the previous snapshot
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @importFrom dplyr bind_rows
#' @importFrom cli cli_alert_warning
#'
#' @return Appended lSnapshot object
#'
#' @export
#'
#' @keywords internal
AppendLogs <- function(lPrevSnapshot, lSnapshot, files = names(lPrevSnapshot$lSnapshot), bQuiet = FALSE){
  if(is.null(lPrevSnapshot)){
    if (!bQuiet) cli::cli_alert_warning("`lPrevSnapshot` argument is NULL `lStackedSnapshots` will only contain current lSnapshot logs")
    return(lSnapshot)
  } else {
    snapshot <- ifelse("lStackedSnapshots" %in% names(lPrevSnapshot), "lStackedSnapshots", "lSnapshot")
    prev_snap_fixed <- Match_Class(lPrevSnapshot, lSnapshot)
    appendedlogs <- list()
    for(i in files[files %in% names(lSnapshot)]){
      appendedlogs[[i]] <- dplyr::bind_rows(lSnapshot[[i]], prev_snap_fixed[[snapshot]][[i]])
    }
    files_not_appended <- setdiff(names(lSnapshot), names(appendedlogs))
    if (length(files_not_appended) != 0) {
      cli::cli_alert_warning("{files_not_appended} were not appended in `lStackedSnapshots` because they were not found in `lPrevSnapshot` or `append_files` argument")
    }
    output <- c(appendedlogs, lSnapshot[files_not_appended])
    return(output)
  }
}

#' Appends the previous snapshot logs to the current snapshot logs
#'
#' @param prev_lSnapshot `list` the previous Snapshot object
#' @param lSnapshot `list` the current Snapshot object
#' @param files `vector` Optional vector of desired files to append, defaults to all files within the previous snapshot
#'
#' @importFrom dplyr bind_rows
#'
#' @return Appended lSnapshot object
#'
#' @export
#'
#' @keywords internal

MakeWorkflowHistory <- function(lStackedSnapshots){
  if("rpt_site_kri_details" %in% names(lStackedSnapshots)){
    lStackedSnapshots$rpt_site_kri_details %>%
      distinct(.data$gsm_analysis_date, .data$workflowid) %>%
      group_by(.data$workflowid) %>%
      summarise(
        latest_active_status = max(as.Date(.data$snapshot_date), na.rm = TRUE),
        .groups = "drop"
      )
  } else {
    cli::cli_alert_warning("`latest_active_status` in `status_workflow` can't be determined. 'rpt_site_kri_details' missing from `lPrevSnapshot` or `append_files` argument")
  }
}


#' Appends the previous snapshot lStudyAssessResults to the current snapshot lStudyAssessResults
#'
#' @param lPrevSnapshot `list` the previous Snapshot object
#' @param lResults `list` the current lResults created in `Make_Snapshot`
#'
#' @return Appended lSnapshot object
#'
#' @export
#'
#' @keywords internal
AppendDroppedWorkflows <- function(lPrevSnapshot, lResults) {
  for (workflowid in names(lResults)) {
    lResults[[workflowid]][["bActive"]] <- TRUE
  }

  if (is.null(lPrevSnapshot)) {
    return(lResults)
  } else {
    dropped_workflows <- setdiff(names(lPrevSnapshot$lStudyAssessResults), names(lResults))

    if (length(dropped_workflows) > 0) {
      for (workflowid in dropped_workflows) {
        lResults[[workflowid]] <- lPrevSnapshot$lStudyAssessResults[[workflowid]]
        lResults[[workflowid]][["bActive"]] <- FALSE
      }
    }
  }

  return(lResults)
}

#' MakeRptStudySnapshot
#'
#' The function MakeRptStudySnapshot takes two inputs, lMeta and strAnalysisDate, and returns a data frame as output.
#'
#' @param lMeta A list containing metadata information about the study.
#' @param strAnalysisDate A string representing the analysis date.
#'
#' @return A data frame with columns study_id, snapshot_date, is_latest, next_snapshot_date, pt_cycle_id, and pt_data_dt.
#'
#'
#' @export
#' @keywords internal
MakeRptStudySnapshot <- function(lMeta, gsm_analysis_date) {
  output <- data.frame(
    study_id = unique(lMeta$meta_study$protocol_number),
    snapshot_date = gsm_analysis_date,
    is_latest = TRUE,
    next_snapshot_date = NA_character_,
    pt_cycle_id = NA_character_,
    pt_data_dt = NA_character_
  )

  return(output)
}


#' SubsetStackedSnapshots
#'
#' @description
#' This function is used to subset a list of stacked snapshots within [gsm::Make_Snapshot()].
#'
#' @param strWorkflowId `character` workflow ID.
#'
#'
#' @keywords internal
SubsetStackedSnapshots <- function(strWorkflowId, lStackedSnapshots) {
  subset_snapshots <- purrr::map(lStackedSnapshots, function(x) {

    if ("workflowid" %in% names(x)) {
      x %>%
        filter(
          .data$workflowid == strWorkflowId
        )
    } else {
      x
    }

  }) %>%
    purrr::discard(is.null)

  return(subset_snapshots)
}
