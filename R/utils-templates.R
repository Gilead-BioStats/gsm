#' Create testthat skeleton
#'
#' @param mapping coming soon...
#'
#'
#' @examples
#' \dontrun{
#' use_gsm_test() # default is "map"
#' use_gsm_test("ae_map")
#' use_gsm_test("ie_map")
#' }
use_gsm_test <- function(mapping = NULL) {

  stopifnot(
    "mapping currently supports: 'ae_map', 'ie_map', 'pd_map', and 'consent_map'" = !mapping %in% c('ae_map', 'ie_map', 'pd_map', 'consent_map')
  )

  if (!requireNamespace("here", quietly = TRUE)) {
    stop("Package '{here}' is required for this function: \ninstall.packages('here')\nlibrary(here)")
  }

  if (!requireNamespace("usethis", quietly = TRUE)) {
    stop("Package '{usethis}' is required for this function: \ninstall.packages('usethis')\nlibrary(usethis)")
  }

  if (!requireNamespace("stringr", quietly = TRUE)) {
    stop("Package '{stringr}' is required for this function: \ninstall.packages('stringr')\nlibrary(stringr)")
  }

  if (!requireNamespace("yaml", quietly = TRUE)) {
    stop("Package '{yaml}' is required for this function: \ninstall.packages('yaml')\nlibrary(yaml)")
  }

  create <- yaml::read_yaml(here::here("inst", "templates", "templateMappings.yaml"))

  create <- create[[mapping]]

  outputDir <- paste0(here::here("tests", "testthat"), "/test_AUTO", create[["fun"]], ".R")

  skeleton <- readLines(here::here("inst", "templates", "testthat_map.R")) %>%
    stringr::str_replace("X_Map_Raw", create[["fun"]]) %>%
    stringr::str_replace("input1", create[["input1"]]) %>%
    stringr::str_replace("input2", create[["input2"]])

  skeleton %>%
    writeLines(outputDir)

  usethis::edit_file(
    path = outputDir,
    open = rlang::is_interactive()
  )

}
