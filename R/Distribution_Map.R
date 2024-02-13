#' Map through raw data for distribution of causes checked in kri's
#'
#' @param lSnapshot `list` a snapshot object from `Make_Snapshot()`
#' @param dist_list `list` a list of data and linked category columns
#' @param lMapping `list` a list of predefined columns to map over
#'
#' @keywords internal
#'
#' @export
#'
Distribution_Map <- function(lSnapshot, dist_list, lMapping){
  subj_filt <- c(lMapping$dfSUBJ[["strStudyCol"]],
                 lMapping$dfSUBJ[["strSiteCol"]],
                 lMapping$dfSUBJ[["strIDCol"]],
                 lMapping$dfSUBJ[["strEDCIDCol"]])

  has_site <- map(lMapping[names(lMapping) %in% map_vec(dist_list, ~.[1])], ~exists("strSiteCol", .))
  output <- list()
  lDomain <- map(dist_list, function(kri){
    strDomain <- kri[1]
    strCol <- kri[2]
    site <- has_site[[strDomain]]
    strSubjCol <- ifelse(strDomain %in% c("dfQUERY", "dfDATAENT", "dfDATACHG"), "strEDCIDCol", "strIDCol")
    joining <- joining_map(dist_list, lMapping, strDomain, strSubjCol, site)
    output$kri <- lSnapshot$lInputs$lData$dfSUBJ[subj_filt] %>%
      full_join(lSnapshot$lInputs$lData[[strDomain]],
                by = setNames(joining$by_right, joining$by_left)) %>%
      select(
        "Study ID" = lMapping$dfSUBJ[["strStudyCol"]],
        "Site ID" = lMapping$dfSUBJ[["strSiteCol"]],
        "Subject ID" = lMapping$dfSUBJ[[strSubjCol]],
        "Metric" = !!strCol
      ) %>%
      group_by(`Site ID`) %>%
      mutate(Enrolled = n_distinct(`Subject ID`)) %>%
      filter(!is.empty(Metric)) %>%
      group_by(`Site ID`, Metric) %>%
      mutate(Total = n_distinct(`Subject ID`)) %>%
      ungroup() %>%
      mutate(`%` = gt::pct(round(Total/Enrolled * 100, digits = 2)))
  })
  return(lDomain)
}
