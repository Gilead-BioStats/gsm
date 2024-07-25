#' KRI Directionality Logo.
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
#' Reporting utility function to create fontawesome directionality logos`
#'
#' @param flag_value `numeric` Values between -2 and 2.
#' @param title `character` Data that will be passed to the <title> tag.
#'
#' @return A character vector of fontawesome icon SVGs.
#'
#' @export
Report_FormatFlag <- function(flag_value, title = NULL) {
  rlang::check_installed("fontawesome", reason = "to use `Report_FormatFlag()`")
  fa_vector <- vector("character", length = length(flag_value))
  fa_vector[is.na(flag_value)] <- fa_titled("minus", "#AAA", title) # gray
  fa_vector[flag_value == -2] <- fa_titled("angles-down", "#FF5859", title) # red
  fa_vector[flag_value == -1] <- fa_titled("angle-down", "#FEAA02", title) # yellow
  fa_vector[flag_value == 0] <- fa_titled("check", "#3DAF06", title) # green
  fa_vector[flag_value == 1] <- fa_titled("angle-up", "#FEAA02", title) # yellow
  fa_vector[flag_value == 2] <- fa_titled("angles-up", "#FF5859", title) # red

  return(fa_vector)
}

fa_titled <- function(name, fill, title) {
  fontawesome::fa(name, fill = fill, title = title)
}
