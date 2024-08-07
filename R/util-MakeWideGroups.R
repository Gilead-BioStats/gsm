#' Helper function to compile "wide" group metadata
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Used to convert metadata dictionary (dfGroups) to a wide format data frame for
#' use in charts and reports.
#'
#' @inheritParams shared-params
#' @param strGroupLevel A string specifying the group level; used to filter
#'   dfGroups$GroupLevel.
#'
#' @return A long format data frame.
#'
#' @examples
#' MakeWideGroups(reportingGroups, "Site")
#'
#' @export
MakeWideGroups <- function(dfGroups, strGroupLevel) {
  stopifnot(
    "One or more of these columns not found: GroupID, GroupLevel, Param, Value" =
      all(c("GroupID", "GroupLevel", "Param", "Value") %in% names(dfGroups))
  )
  df_wide <- dfGroups %>%
    dplyr::filter(.data$GroupLevel == strGroupLevel) %>%
    tidyr::pivot_wider(
      names_from = "Param",
      values_from = "Value"
    )
  return(df_wide)
}
