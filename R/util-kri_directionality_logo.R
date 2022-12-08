#' KRI Directionality Logo
#'
#' @description
#' Reporting utility function to create fontawesome directionality logos within `DT::datatable()`
#'
#' @param flag_value `numeric` Value between -2 and 2.
#'
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
