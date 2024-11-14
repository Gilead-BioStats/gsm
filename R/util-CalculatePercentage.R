#' Helper function to compile "long" group metadata
#'
#' @description
#'
#' Used to create percentage values on enrollment data, such as site activation and
#' and participantment enrollment, and pasting together an appropriate n/N (xx.x%) value
#' as well.
#'
#' @param data The input dataframe
#' @param strCurrentCol Column that represents site count or participant count
#' @param strTargetCol Column that represents the target count for site/participants
#' @param strPercVal Name of column that will contain the numeric percentage value on enrollment
#' @param strPercStrVal Name of column that will contain the n/N (xx.x%) string
#'
#' @return A data frame containing two additional columns for the precentage value and associated string
#' @export
CalculatePercentage <- function(data, strCurrentCol, strTargetCol, strPercVal, strPercStrVal) {
  if (!(strCurrentCol %in% names(data))) {
    cli::cli_abort("Check that both {strCurrentCol} and {strTargetCol} are in data")
  }

  if (strTargetCol %in% names(data)) {
    data <- data %>%
      dplyr::mutate(
        {{ strPercVal }} := round(.data[[strCurrentCol]] * 100 / .data[[strTargetCol]], 1),
        {{ strPercStrVal }} := paste0(.data[[strCurrentCol]], " / ", .data[[strTargetCol]], " (", .data[[strPercVal]], "%)")
      )
  } else {
    data <- data %>%
      dplyr::mutate(
        {{ strPercStrVal }} := .data[[strCurrentCol]]
      )
  }

  return(data)
}
