#' Report helper functions used to create fontawesome status icons for the report that is generated with [gsm::Study_Report].
#'
#' `r lifecycle::badge("experimental")`
#'
#' @description
#' `rank_chg` - inserts icons for status in {gt} table.
#'
#' Adopted from https://themockup.blog/posts/2020-10-31-embedding-custom-features-in-gt-tables/.
#'
#' @param status `boolean` fontawesome emoji indicator that describes the status of error checking for all assessments run in `Study_Assess()`
#'
#' @export

rank_chg <- function(status) {
  rlang::check_installed("gt", reason = "to use `rank_chg`")
  rlang::check_installed("fontawesome", reason = "to use `rank_chg`")

  if (status == 1) {
    logo_out <- fontawesome::fa("circle", fill = "green")
  }
  if (status == 2) {
    logo_out <- fontawesome::fa("circle", fill = "red")
  }
  if (status == 3) {
    logo_out <- fontawesome::fa("circle", fill = "#EED202")
  }
  gt::html(as.character(logo_out))
}
