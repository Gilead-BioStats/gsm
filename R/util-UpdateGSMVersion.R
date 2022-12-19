#' Update GSM Version
#'
#' @description
#' Automatically updates metadata that relies on the current `{gsm}` version.
#'
#' @param version If `NULL` (the default), updates metadata to current version as indicated in the DESCRIPTION file.
#'
#' @return Updated metadata. Currently [gsm::meta_param] and [gsm::meta_workflow]
#'
#' @examples
#' \dontrun{
#' UpdateGSMVersion()
#' }
#'
#' @importFrom utils packageVersion write.csv
#' @importFrom here here
#' @importFrom purrr map set_names iwalk
#'
#' @export
UpdateGSMVersion <- function(version = NULL) {
  if (is.null(version)) {
    version <- as.character(utils::packageVersion("gsm"))
  }

  meta_update <- c("meta_param.csv", "meta_workflow.csv")

  lMeta_update <- purrr::map(meta_update, ~ read.csv(here::here("data-raw", .x))) %>%
    purrr::map(~ .x %>% mutate(gsm_version = version)) %>%
    purrr::set_names(meta_update)

  purrr::iwalk(lMeta_update, ~ utils::write.csv(.x, file = paste0(here::here("data-raw", .y)), row.names = FALSE))

  source(here::here("data-raw", "meta_param.R"))
  source(here::here("data-raw", "meta_workflow.R"))
}
