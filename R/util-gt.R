#' Shared gt arguments
#'
#' #' @description
#'
#' Reusable definitions of common gt arguments.
#'
#' @param data A `gt_tbl` object.
#' @param columns Columns to target for formatting.
#' @return An object of class `gt_tbl`.
#'
#' @name gt-shared
#' @keywords internal
NULL

#' Create a gt table object with gsm style
#'
#'  @description
#'
#' This is a wrapper to ensure that the user has gt installed and to apply
#' standardized styles.
#'
#' @inheritParams gt-shared
#' @param ... Additional arguments passed to [gt::gt()].
#' @inherit gt-shared return
#' @keywords internal
gsm_gt <- function(data, ...) {
  rlang::check_installed("gt")
  gt_style(gt::gt(data, ...))
}

#' Shared formats for gt tables
#'
#' @description
#'
#' Apply standardized formatting to gt tables.
#'
#' @inheritParams gt-shared
#' @inherit gt-shared return
#' @keywords internal
gt_style <- function(data) {
  rlang::check_installed("gt")
  gt::opt_vertical_padding(data, 0.5)
}

#' Month and year columns for gt tables
#'
#' @description
#'
#' Split date columns in the style "YYYY-MM" or "YYYY-MM-DD" into month columns
#' with year spanners.
#'
#' @inheritParams gt-shared
#' @inherit gt-shared return
#' @keywords internal
cols_label_month <- function(data, columns = gt::everything()) {
  rlang::check_installed("gt")
  gt::cols_label_with(
    data,
    columns = columns,
    fn = function(x) {
      months(as.Date(x), abbreviate = TRUE)
    }
  ) %>%
    gt::tab_spanner_delim(
      delim = "-",
      columns = columns,
      split = "first",
      limit = 1
    )
}
