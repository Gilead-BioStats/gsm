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
             snapshot_date = .data$gsm_analysis_date)
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



# look for results_analysis and include if it exists ----------------------
  results_analysis_exists <- map_lgl(list.files(cDirectory), function(x) {
    "results_analysis.csv" %in% list.files(paste0(cDirectory, "/", x))
  })

  if(any(results_analysis_exists)) {
    results_analysis <- purrr::imap_dfr(list.files(cDirectory), function(x, index) {
      if (results_analysis_exists[index]) {
        read.csv(paste0(cDirectory, "/", x, "/results_analysis.csv")) %>%
          mutate(gsm_analysis_date = as.Date(.data$gsm_analysis_date, "%Y-%m-%d"))
      } else {
        return(NULL)
      }
    })
  }

# append recent data ------------------------------------------------------
  if (!is.null(lSnapshot)) {
    results_summary <- bind_rows(
      results_summary,
      lSnapshot$lSnapshot$results_summary %>%
        mutate(
          snapshot_date = .data$gsm_analysis_date
        )
    )

    if ("results_analysis" %in% names(lSnapshot$lSnapshot)) {
      results_analysis <- bind_rows(
        results_analysis,
        lSnapshot$lSnapshot$results_analysis
      )
    }

  }

  all_data <- list(
    results_summary = results_summary,
    params = params,
    meta_workflow = lSnapshot$lSnapshot$meta_workflow, # only get most recent meta_workflow
    status_study = lSnapshot$lSnapshot$status_study,   # only get most recent status_study
    results_analysis = results_analysis
  )

  return(all_data)

}




