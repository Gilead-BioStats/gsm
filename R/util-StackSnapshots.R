#' `r lifecycle::badge("experimental")`
#'
#' Create longitudinal snapshot from results_summary.
#'
#' @param cPath `character` Path to longitudinal data folders.
#' @param lSnapshot `list` Optional. Pass the output of [gsm::Make_Snapshot()] to be appended to historical results.
#' @param vFolderNames `vector` Name(s) of folder(s) found within `cPath` to use. Any folders not specified will not be used in the augment.
#'
#' @return `data.frame` containing longitudinal snapshots of `{gsm}` analyses.
#'
#' @examples
#' \dontrun{
#' sim <- clindata::run_simulation(n_sites = 20, n_subjects = 250)
#' dir <- here::here("simulation", "study-20_sites-250_subjects")
#' results_summary_over_time <- StackSnapshots(cPath = dir)
#' }
#'
#' @importFrom purrr map_df
#' @importFrom stats na.omit
#'
#' @export
StackSnapshots <- function(
    cPath,
    lSnapshot = NULL,
    vFolderNames = NULL
) {
  stopifnot(
    "[ cPath ] does not exist." = file.exists(cPath)
  )

  # Capture list of YYYY-MM-DD-formatted snapshot directoreis.
  snapshots <- list.dirs(cPath, recursive = FALSE) %>%
      .[grepl('/\\d{4}-\\d{2}-\\d{2}$', .)]

  # subset snapshot folders if specified ------------------------------------
  if (!is.null(vFolderNames)) {

    folders_not_found <- vFolderNames[!vFolderNames %in% basename(snapshots)]

    if (length(folders_not_found) > 0) {
      cli::cli_alert_danger("{length(folders_not_found)} folder{?s} not found! Missing: {.strong `{folders_not_found}`}")
    }

    snapshots <- snapshots[basename(snapshots) %in% vFolderNames]
  }

  stopifnot(
    "[ cPath ] contains no dated folders formatted YYYY-MM-DD." = length(snapshots) > 0
  )



  gsm_tables <- c(
    "meta_param",
    "meta_workflow",
    "results_analysis",
    "results_summary",
    "status_param",
    "status_site",
    "status_study",
    "status_workflow"
  )

  # iterate over tables
  longitudinal_data <- gsm_tables %>%
    map(function(gsm_table) {
      # iterate over snapshots
      gsm_data <- snapshots %>%
        purrr::map_dfr(function(snapshot) {
          # if table exists read it in
          file_path <- glue::glue("{snapshot}/{gsm_table}.csv")

          if (file.exists(file_path)) {
            data <- file_path %>%
              read.csv(
                colClasses = "character"
              ) %>%
              mutate(
                gsm_analysis_date = as.Date(.data$gsm_analysis_date, "%Y-%m-%d"),
                snapshot_date = .data$gsm_analysis_date
              )

            return(data)
          } else {
            cli::cli_alert_warning("[ {gsm_table} ] not found in [ {snapshot} ].")

            return(NULL)
          }
        })

      return(gsm_data)
    }) %>%
    rlang::set_names(gsm_tables)

  # append recent data ------------------------------------------------------
  if (!is.null(lSnapshot)) {

    common_tables <- intersect(
      names(longitudinal_data),
      names(lSnapshot$lSnapshot)
    )

    if (length(common_tables) < length(gsm_tables)) {
      cli::cli_alert_warning("[ Table{?s} {setdiff(gsm_tables, common_tables)} ] not found in [ {.code lSnapshot} ]")
    }

    for (common_table in common_tables) {
      # coerce column types in longitudinal data to match column types in snapshot data
      common_columns <- intersect(
        names(longitudinal_data[[common_table]]),
        names(lSnapshot$lSnapshot[[common_table]])
      )

      for (common_column in common_columns) {
        expected_class <- class(lSnapshot$lSnapshot[[common_table]][[common_column]])[1]
        detected_class <- class(longitudinal_data[[common_table]][[common_column]])[1]

        if (expected_class != detected_class) {
          longitudinal_data[[common_table]][[common_column]] <- match.fun(paste0("as.", expected_class))(
            longitudinal_data[[common_table]][[common_column]]
          )
        }
      }

      longitudinal_data[[common_table]] <- longitudinal_data[[common_table]] %>%
        bind_rows(
          lSnapshot$lSnapshot[[common_table]] %>%
            mutate(
              snapshot_date = .data$gsm_analysis_date
            )
        )
    }
  }


  # make parameters -------------------------------------------------------------
  longitudinal_data$parameters <- longitudinal_data$meta_param %>%
    left_join(
      longitudinal_data$status_param,
      by = join_by("workflowid", "param", "index", "gsm_analysis_date", "snapshot_date")
    ) %>%
    select(-c("default", "configurable"))

  # check if gsm_versions are mismatched
  if (any(c("gsm_version.x", "gsm_version.y") %in% names(longitudinal_data$parameters))) {

    # parse the version to a numeric representation
    # -- e.g., "v1.6.0" becomes 160, "v1.7.1" becomes 171
    # -- in the `parameters` data.frame, default to the most recent {gsm} version
    gsm_most_recent <- ifelse(
      get_numeric_version(longitudinal_data$parameters$gsm_version.x) >= get_numeric_version(longitudinal_data$parameters$gsm_version.y),
      unique(stats::na.omit(
        longitudinal_data$parameters$gsm_version.x
      )),
      unique(stats::na.omit(
        longitudinal_data$parameters$gsm_version.y
      ))
    )

    longitudinal_data$parameters <- longitudinal_data$parameters %>%
      mutate(
        gsm_version = gsm_most_recent
      ) %>%
      select(
        -c("gsm_version.x", "gsm_version.y")
      )

  }

  # only keep latest workflow metadata
  if ("meta_workflow" %in% names(longitudinal_data)) {
    longitudinal_data$meta_workflow <- longitudinal_data$meta_workflow %>%
      filter(
        .data$gsm_analysis_date == max(.data$gsm_analysis_date)
      )
  }




  return(longitudinal_data)
}


get_numeric_version <- function(strVersion) {
  unique(as.numeric(paste(as.numeric(strsplit(stats::na.omit(strVersion), "\\.")[[1]]), collapse = '')))
}
