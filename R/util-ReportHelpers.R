
#' insert icon for status in gt table
#'
#' from https://themockup.blog/posts/2020-10-31-embedding-custom-features-in-gt-tables/
#'
#' @param status boolean status
#'
#' @export

rank_chg <- function(status) {
  if (status == 1) {
    logo_out <- fontawesome::fa("check-circle", fill = "green")
  }
  if (status == 2) {
    logo_out <- fontawesome::fa("times-circle", fill = "red")
  }
  if (status == 3) {
    logo_out <- fontawesome::fa("minus-circle", fill = "#EED202")
  }
  gt::html(as.character(logo_out))
}
