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

#' @export
kri_directionality_logo <- function(flag_value) {
  if (flag_value == -2) {
    a <- fontawesome::fa("angles-down", fill = "#FF5859") # red
  }

  if (flag_value == -1) {
    a <- fontawesome::fa("angle-down", fill = "#FEAA02") # yellow
  }
  if (flag_value == 0) {
    a <- fontawesome::fa("check", fill = "#3DAF06") # green
  }
  if (flag_value == 1) {
    a <- fontawesome::fa("angle-up", fill = "#FEAA02")
  }
  if (flag_value == 2) {
    a <- fontawesome::fa("angles-up", fill = "#FF5859")
  }
  return(a)
}
