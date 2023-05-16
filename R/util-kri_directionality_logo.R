#' `r lifecycle::badge("stable")`
#'
#' KRI Directionality Logo.
#'
#' @description
#' Reporting utility function to create fontawesome directionality logos within `DT::datatable()`
#'
#' @param flag_value `numeric` Value between -2 and 2.
#' @param title `character` Data that will be passed to the <title> tag.
#'
#' @export
kri_directionality_logo <- function(flag_value, title = NULL) {
  if (is.na(flag_value)) {
    return(fontawesome::fa("minus", fill = "#aaa", title = title))
  }

  if (flag_value == -2) {
    a <- fontawesome::fa("angles-down", fill = "#FF5859", title = title) # red
  }

  if (flag_value == -1) {
    a <- fontawesome::fa("angle-down", fill = "#FEAA02", title = title) # yellow
  }

  if (flag_value == 0) {
    a <- fontawesome::fa("check", fill = "#3DAF06", title = title) # green
  }

  if (flag_value == 1) {
    a <- fontawesome::fa("angle-up", fill = "#FEAA02", title = title)
  }

  if (flag_value == 2) {
    a <- fontawesome::fa("angles-up", fill = "#FF5859", title = title)
  }

  return(a)
}
