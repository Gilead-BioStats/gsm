#' Report Helper Functions
#'
#' @description
#' `rank_chg` - inserts icons for status in {gt} table.
#'
#' Adopted from https://themockup.blog/posts/2020-10-31-embedding-custom-features-in-gt-tables/.
#'
#' @param status `boolean` fontawesome emoji indicator that describes the status of error checking for all assessments run in `Study_Assess()`
#'
#' @importFrom fontawesome fa
#' @importFrom gt gt
#'
#' @export

rank_chg <- function(status) {
  if (status == 1) {
    logo_out <- fontawesome::fa("circle-check", fill = "green")
  }
  if (status == 2) {
    logo_out <- fontawesome::fa("circle-xmark", fill = "red")
  }
  if (status == 3) {
    logo_out <- fontawesome::fa("circle-minus", fill = "#EED202")
  }
  gt::html(as.character(logo_out))
}
