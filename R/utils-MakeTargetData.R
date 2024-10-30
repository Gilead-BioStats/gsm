#' Helper function to compile "long" group metadata
#'
#' @description
#'
#' Used to create percentage values on enrollment data, such as site activation and
#' and participantment enrollment, and pasting together an appropriate n/N (xx.x%) value
#' as well.
#'
#' @param data The input dataframe
#' @param current_col Column that represents site count or participant count
#' @param target_col Column that represents the target count for site/participants
#' @param perc_val Name of column that will contain the numeric percentage value on enrollment
#' @param perc_str_val Name of column that will contain the n/N (xx.x%) string
#'
#' @return
#' @export
#'
#' @examples
MakeTargetData <- function(data, current_col, target_col, perc_val, perc_str_val) {
  if (!(current_col %in% names(data) & target_col %in% names(data))) {
    cli::cli_abort("Check that both {current_col} and {target_col} are in data")
  }

  data <- data %>%
    dplyr::mutate(
      {{ perc_val }} := round(.data[[current_col]] * 100 / .data[[target_col]], 1),
      {{ perc_str_val }} := paste0(.data[[current_col]], " / ", .data[[target_col]], " (", .data[[perc_val]], " %)")
    )

  return(data)
}
