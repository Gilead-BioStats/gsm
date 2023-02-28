#' Create longitudinal snapshot from results_summary.
#'
#' @param dir
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
MakeTimeSeriesLongitudinal <- function(dir) {

  results_summary <- purrr::map_df(list.files(dir), function(x) {
    read.csv(paste0(dir, "/", x, "/results_summary.csv"))
  })

  status_param <- purrr::map_df(list.files(dir), function(x) {
    read.csv(paste0(dir, "/", x, "/status_param.csv"))
  })

  meta_param <- purrr::map_df(list.files(dir), function(x) {
    read.csv(paste0(dir, "/", x, "/meta_param.csv")) %>%
      mutate(gsm_analysis_date = as.Date(gsm_analysis_date, "%Y-%m-%d"))
  }) %>%
    filter(gsm_analysis_date == max(gsm_analysis_date))

  meta_workflow <- purrr::map_df(list.files(dir), function(x) {
    read.csv(paste0(dir, "/", x, "/meta_workflow.csv")) %>%
      mutate(gsm_analysis_date = as.Date(gsm_analysis_date, "%Y-%m-%d"))
  }) %>%
    filter(gsm_analysis_date == max(gsm_analysis_date))

  list(
    results_summary = results_summary,
    status_param = status_param,
    meta_param = meta_param,
    meta_workflow = meta_workflow
  )

}




