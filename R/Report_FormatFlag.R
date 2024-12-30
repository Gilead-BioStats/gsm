#' KRI Directionality Logo.
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
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
  fa_vector[is.na(flag_value)] <- fa_titled("minus", colorScheme("gray", "dark"), title)
  fa_vector[flag_value == -2] <- fa_titled("angles-down", colorScheme("red", "dark"), title)
  fa_vector[flag_value == -1] <- fa_titled("angle-down", colorScheme("amber", "dark"), title)
  fa_vector[flag_value == 0] <- fa_titled("check", colorScheme("green", "dark"), title)
  fa_vector[flag_value == 1] <- fa_titled("angle-up", colorScheme("amber", "dark"), title)
  fa_vector[flag_value == 2] <- fa_titled("angles-up", colorScheme("red", "dark"), title)

  return(fa_vector)
}

fa_titled <- function(name, fill, title) {
  fontawesome::fa(name, fill = fill, title = title)
}

