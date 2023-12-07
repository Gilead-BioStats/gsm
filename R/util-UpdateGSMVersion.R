#' Update GSM Version (`gsm_version` column) in metadata for [gsm::meta_param] and [gsm::meta_workflow].
#'
#' `r lifecycle::badge("experimental")`
#'
#' @description
#' Automatically updates metadata that relies on the current `{gsm}` version. Exported `{gsm}` data, as well as raw `.csv` files are updated.
#'
#' @param version If `NULL` (the default), updates metadata to current version as indicated in the DESCRIPTION file.
#'
#' @return Updated metadata. Currently [gsm::meta_param] and [gsm::meta_workflow].
#'
#' @examples
#' \dontrun{
#' UpdateGSMVersion()
#' }
#'
#' @importFrom utils packageVersion write.csv
#' @importFrom here here
#' @importFrom purrr map set_names iwalk
#' @importFrom cli cli_alert_success
#'
#' @export
UpdateGSMVersion <- function(version = NULL) {
  if (is.null(version)) {
    version <- as.character(utils::packageVersion("gsm"))
  }

  cli::cli_alert_success("Setting {.pkg gsm} version to {.strong {version}}")

  meta_update <- c("meta_param.csv", "meta_workflow.csv", "config_param.csv", "config_workflow.csv")

  lMeta_update <- purrr::map(meta_update, ~ read.csv(here::here("data-raw", .x))) %>%
    purrr::map(~ .x %>% mutate(gsm_version = version)) %>%
    purrr::set_names(meta_update)

  purrr::iwalk(lMeta_update, ~ utils::write.csv(.x, file = paste0(here::here("data-raw", .y)), row.names = FALSE))

  source(here::here("data-raw", "meta_param.R"))
  source(here::here("data-raw", "meta_workflow.R"))
  source(here::here("data-raw", "config_param.R"))
  source(here::here("data-raw", "config_workflow.R"))
}
