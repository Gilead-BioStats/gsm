#' Create testthat skeleton
#'
#' @param type Choose "map" or "assess", depending on the type of test file you need.
#'
#' @examples
#' \dontrun{
#' use_gsm_test() # default is "map"
#' use_gsm_test("map")
#' use_gsm_test("assess")
#' }
use_gsm_test <- function(type = "map") {

  stopifnot(
    '"type" must be "map" or "assess"' = tolower(type) %in% c("map", "assess")
    )

  if (tolower(type) == "map") {
    fileName <- "/testthat_map.R"
  }

  if (tolower(type) == "assess") {
    fileName <- "/testthat_assess.R"
  }

  path <- paste0(
    here::here("inst", "templates"),
    fileName
    )

  usethis::edit_file(
    path = path,
    open = rlang::is_interactive()
  )

}
