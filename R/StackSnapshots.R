function(cPath, lSnapshot = NULL, vFolderNames = NULL) {
  stopifnot(`[ cPath ] does not exist.` = file.exists(cPath))
  snapshots <- ExtractDirectoryPaths(cPath, file = c(
    "meta_param.csv",
    "meta_workflow.csv", "results_analysis.csv", "results_summary.csv",
    "status_param.csv", "status_site.csv", "status_study.csv",
    "status_workflow.csv"
  ), verbose = FALSE)
  if (length(snapshots) > 0) {
    if (!is.null(vFolderNames)) {
      folders_not_found <- vFolderNames[!vFolderNames %in%
        basename(snapshots)]
      if (length(folders_not_found) > 0) {
        cli::cli_alert_danger("{length(folders_not_found)} folder{?s} not found! Missing: {.strong `{folders_not_found}`}")
      }
      snapshots <- snapshots[basename(snapshots) %in% vFolderNames]
    }
    gsm_tables <- c(
      "meta_param", "meta_workflow", "results_analysis",
      "results_summary", "status_param", "status_site",
      "status_study", "status_workflow"
    )
    longitudinal_data <- gsm_tables %>%
      map(function(gsm_table) {
        gsm_data <- snapshots %>% purrr::map_dfr(function(snapshot) {
          file_path <- glue::glue("{snapshot}/{gsm_table}.csv")
          if (file.exists(file_path)) {
            data <- file_path %>%
              read.csv(colClasses = "character") %>%
              mutate(gsm_analysis_date = as.Date(
                .data$gsm_analysis_date,
                "%Y-%m-%d"
              ), snapshot_date = as.Date(
                .data$gsm_analysis_date,
                "%Y-%m-%d"
              ))
            return(data)
          } else {
            cli::cli_alert_warning("[ {gsm_table} ] not found in [ {snapshot} ].")
            return(NULL)
          }
        })
        return(gsm_data)
      }) %>%
      rlang::set_names(gsm_tables)
    if (!is.null(lSnapshot)) {
      common_tables <- intersect(
        names(longitudinal_data),
        names(lSnapshot$lSnapshot)
      )
      if (length(common_tables) < length(gsm_tables)) {
        cli::cli_alert_warning("[ Table{?s} {setdiff(gsm_tables, common_tables)} ] not found in [ {.code lSnapshot} ]")
      }
      for (common_table in common_tables) {
        common_columns <- intersect(
          names(longitudinal_data[[common_table]]),
          names(lSnapshot$lSnapshot[[common_table]])
        )
        for (common_column in common_columns) {
          expected_class <- class(lSnapshot$lSnapshot[[common_table]][[common_column]])[1]
          detected_class <- class(longitudinal_data[[common_table]][[common_column]])[1]
          if (expected_class != detected_class) {
            longitudinal_data[[common_table]][[common_column]] <- match.fun(paste0(
              "as.",
              expected_class
            ))(longitudinal_data[[common_table]][[common_column]])
          }
        }
        longitudinal_data[[common_table]] <- longitudinal_data[[common_table]] %>%
          bind_rows(lSnapshot$lSnapshot[[common_table]] %>%
            mutate(snapshot_date = as.Date(
              .data$gsm_analysis_date,
              "%Y-%m-%d"
            )))
      }
    }
    longitudinal_data$parameters <- longitudinal_data$meta_param %>%
      left_join(longitudinal_data$status_param, by = join_by(
        "workflowid",
        "param", "index", "gsm_analysis_date", "snapshot_date"
      )) %>%
      select(-c("default", "configurable"))
    if (any(c("gsm_version.x", "gsm_version.y") %in% names(longitudinal_data$parameters))) {
      versions_x <- unique(longitudinal_data$parameters$gsm_version.x) %>%
        stats::na.omit()
      versions_y <- unique(longitudinal_data$parameters$gsm_version.y) %>%
        stats::na.omit()
      latest_version <- max(base::as.package_version(c(
        versions_x,
        versions_y
      )))
      other_versions <- sort(unique(c(versions_x, versions_y)[!c(
        versions_x,
        versions_y
      ) %in% as.character(latest_version)]))
      longitudinal_data$parameters <- longitudinal_data$parameters %>%
        mutate(gsm_version = as.character(latest_version)) %>%
        select(-c("gsm_version.x", "gsm_version.y"))
      cli::cli_alert_warning("{.fun StackSnapshot} detected multiple versions of {.pkg gsm} in snapshot history.")
      cli::cli_li("Using latest version {.code {latest_version}} in the longitudinal data added to snapshot.")
      cli::cli_li("Also detected version{?s} {.code {other_versions}}.")
    }
    if ("meta_workflow" %in% names(longitudinal_data)) {
      longitudinal_data$meta_workflow <- longitudinal_data$meta_workflow %>%
        filter(.data$gsm_analysis_date == max(.data$gsm_analysis_date))
    }
    return(longitudinal_data)
  } else {
    cli::cli_alert_warning("[ cPath ] contains no additional snapshot folders to derive longinitudinal data. Original snapshot is returned instead.")
    return(NULL)
  }
}
