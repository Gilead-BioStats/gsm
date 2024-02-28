#' Map treatment completion data to output for discontinuation report
#'
#' @param dfSDRGCOMP `data.frame` treatment completion data to map
#' @param lMapping `list` mapping variables to use
#'
#' @export
#'
#' @keywords internal
Disc_Treatment_Map <- function(dfSDRGCOMP, lMapping){
  dfSDRGCOMP %>%
    select(
      "Study ID" = lMapping[["dfSDRGCOMP"]][["strStudyCol"]],
      "Site ID" = lMapping[["dfSDRGCOMP"]][["strSiteCol"]],
      "Subject ID" = lMapping[["dfSDRGCOMP"]][["strIDCol"]],
      "Discontinuation Reason" = lMapping[["dfSDRGCOMP"]][["strTreatmentDiscontinuationReasonCol"]]
    ) %>%
    group_by(`Site ID`) %>%
    mutate(Enrolled = n()) %>%
    filter(!is.empty(`Discontinuation Reason`)) %>%
    group_by(`Site ID`, `Discontinuation Reason`) %>%
    mutate(Discontinued = n()) %>%
    ungroup() %>%
    mutate(`%` = pct(round(Discontinued/Enrolled * 100, digits = 2)))
}
