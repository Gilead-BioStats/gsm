#' Create longitudinal snapshot from results_summary.
#'
#' @param cDirectory `character` Path to longitudinal data folders.
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
MakeTimeSeriesLongitudinal <- function(cDirectory) {

  results_summary <- purrr::map_df(list.files(cDirectory), function(x) {
    read.csv(paste0(cDirectory, "/", x, "/results_summary.csv")) %>%
      mutate(snapshot_date = .data$gsm_analysis_date)
  })

  meta_workflow <- purrr::map_df(list.files(cDirectory), function(x) {
    read.csv(paste0(cDirectory, "/", x, "/meta_workflow.csv")) %>%
      mutate(gsm_analysis_date = as.Date(.data$gsm_analysis_date, "%Y-%m-%d"))
  }) %>%
    filter(gsm_analysis_date == max(.data$gsm_analysis_date))


# make params -------------------------------------------------------------

  status_param <- purrr::map_df(list.files(cDirectory), function(x) {
    read.csv(paste0(cDirectory, "/", x, "/status_param.csv")) %>%
      mutate(gsm_analysis_date = as.Date(.data$gsm_analysis_date, "%Y-%m-%d"))
  })

  meta_param <- purrr::map_df(list.files(cDirectory), function(x) {
    read.csv(paste0(cDirectory, "/", x, "/meta_param.csv")) %>%
      mutate(gsm_analysis_date = as.Date(.data$gsm_analysis_date, "%Y-%m-%d"))
  }) %>%
    filter(gsm_analysis_date == max(.data$gsm_analysis_date))

  params <- left_join(
    status_param,
    meta_param,
    by = join_by(.data$workflowid, .data$gsm_version, .data$param, .data$index, .data$gsm_analysis_date)
  ) %>%
    select(-c("default", "configurable")) %>%
    mutate(snapshot_date = as.Date(.data$gsm_analysis_date, "%Y-%d-%m"))

  all_data <- list(
    results_summary = results_summary,
    params = params,
    meta_workflow = meta_workflow
  )

  return(all_data)

}




