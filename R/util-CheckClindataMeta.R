#' `r lifecycle::badge("experimental")`
#'
#' Check gsm_version in clindata metadata.
#'
#' @param config `list` Named list of metadata to check from the `{clindata}` package.
#' @param ci_check `logical` If `TRUE`, return data.frame with results of the version check. If `FALSE` (default), only console messages are returned.
#'
#' @return Console message indicating if `{clindata}` and `{gsm}` versions are compatible.
#'
#' @examples
#' \dontrun{
#' CheckClindataMeta()
#' }
#'
#' @importFrom cli cli_alert_danger cli_alert_success
#' @importFrom purrr imap
#' @importFrom utils packageVersion
#' @importFrom glue glue
#'
#' @export
CheckClindataMeta <- function(
  config = list(
    config_param = clindata::config_param,
    config_workflow = clindata::config_workflow
  ),
  ci_check = FALSE
) {
  config <- config %>%
    purrr::imap(
      ~ .x %>%
        select(gsm_version) %>%
        mutate(
          current_gsm_version = as.character(utils::packageVersion("gsm")),
          data = .y,
          status = gsm_version == current_gsm_version
        ) %>%
        unique()
    ) %>%
    bind_rows()


  if (any(config$status == FALSE)) {
    mismatch <- config %>%
      filter(.data$status == FALSE) %>%
      mutate(warning = glue::glue("clindata table: `{data}` has gsm version {gsm_version} and the current gsm version is {current_gsm_version}"))

    for (warning in mismatch$warning) {
      cli::cli_alert_danger(warning)
    }
  } else {
    cli::cli_alert_success("gsm versions are equivalent for gsm and clindata.")
  }

  if (ci_check) {
    return(config)
  }
}
