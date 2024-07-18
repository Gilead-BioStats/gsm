#' Helper function to compile "wide" group metadata
#'
#' Used to convert metadata dictionary (dfMeta) to a wide format data frame for
#' use in charts and reports.
#'
#' @param dfMeta The meta data dictionary with one row per GroupID per Param.
#'   Must have columns GroupID, GroupLevel, Param, and Value.
#' @param strGroupLevel A string specifying the group level; used to filter
#'   dfMeta$GroupLevel.
#'
#' @return A long format data frame.
#'
#' @examples
#' MakeWideGroups(reportingGroups, "Site")
#'
#' @export
MakeWideGroups <- function(dfMeta, strGroupLevel) {
  stopifnot(
    "One or more of these columns not found: GroupID, GroupLevel, Param, Value" =
      all(c("GroupID","GroupLevel","Param","Value") %in% names(dfMeta))
  )
  df_wide <- dfMeta %>%
    dplyr::filter(.data$GroupLevel == strGroupLevel) %>%
    tidyr::pivot_wider(
      names_from = "Param",
      values_from = "Value"
    )
  return(df_wide)
}
