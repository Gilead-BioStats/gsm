#' Create longitudinal snapshot from results_summary.
#'
#' @param cDirectory `character` Path to longitudinal data folders.
#' @param lSnapshot `list` Optional. Pass the output of [gsm::Make_Snapshot()] to be appended to historical results.
#'
#' @return `data.frame` containing longitudinal snapshots of `{gsm}` analyses.
#'
#' @examples
#'
#' \dontrun{
#' sim <- clindata::run_simulation(n_sites = 20, n_subjects = 250)
#' dir <- here::here("simulation", "study-20_sites-250_subjects")
#' results_summary_over_time <- MakeTimeSeriesLongitudinal(dir = dir)
#' }
#'
#' @importFrom purrr map_df
#'
#' @export
MakeTimeSeriesLongitudinal <- function(cDirectory, lSnapshot = NULL) {

  results_summary <- purrr::map_df(list.files(cDirectory), function(x) {
    read.csv(paste0(cDirectory, "/", x, "/results_summary.csv")) %>%
      mutate(gsm_analysis_date = as.Date(.data$gsm_analysis_date, "%Y-%m-%d"),
             snapshot_date = gsm_analysis_date)
  })

  meta_workflow <- purrr::map_df(list.files(cDirectory), function(x) {
    read.csv(paste0(cDirectory, "/", x, "/meta_workflow.csv")) %>%
      mutate(gsm_analysis_date = as.Date(.data$gsm_analysis_date, "%Y-%m-%d"))
  }) %>%
    filter(.data$gsm_analysis_date == max(.data$gsm_analysis_date))


# make params -------------------------------------------------------------

  status_param <- purrr::map_df(list.files(cDirectory), function(x) {
    read.csv(paste0(cDirectory, "/", x, "/status_param.csv")) %>%
      mutate(gsm_analysis_date = as.Date(.data$gsm_analysis_date, "%Y-%m-%d"))
  })

  meta_param <- purrr::map_df(list.files(cDirectory), function(x) {
    read.csv(paste0(cDirectory, "/", x, "/meta_param.csv")) %>%
      mutate(gsm_analysis_date = as.Date(.data$gsm_analysis_date, "%Y-%m-%d"))
  })

  params <- left_join(
    meta_param,
    status_param,
    by = join_by("workflowid", "gsm_version", "param", "index", "gsm_analysis_date")
  ) %>%
    select(-c("default", "configurable")) %>%
    mutate(snapshot_date = as.Date(.data$gsm_analysis_date, "%Y-%d-%m"))


# metadata for report -----------------------------------------------------
  status_study <- purrr::map_df(list.files(cDirectory), function(x) {
    read.csv(paste0(cDirectory, "/", x, "/status_study.csv")) %>%
      mutate(gsm_analysis_date = as.Date(.data$gsm_analysis_date, "%Y-%m-%d"))
  }) %>%
    filter(.data$gsm_analysis_date == max(.data$gsm_analysis_date))


# append recent data ------------------------------------------------------
  if (!is.null(lSnapshot)) {
    results_summary <- bind_rows(
      results_summary,
      lSnapshot$lSnapshot$results_summary %>%
        mutate(
          snapshot_date = gsm_analysis_date
        )
    )

    meta_workflow <- bind_rows(
      meta_workflow,
      lSnapshot$lSnapshot$meta_workflow
    )

    status_study <- bind_rows(
      status_study,
      lSnapshot$lSnapshot$status_study
    )

  }

  all_data <- list(
    results_summary = results_summary,
    params = params,
    meta_workflow = meta_workflow,
    status_study = status_study
  )

  return(all_data)

}




