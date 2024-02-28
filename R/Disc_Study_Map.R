#' Map study completion data to output for discontinuation report
#'
#' @param dfSTUDCOMP `data.frame` study completion data to map
#' @param lMapping `list` mapping variables to use
#'
#' @export
#'
#' @keywords internal
Disc_Study_Map <- function(dfSTUDCOMP, lMapping){
  dfSTUDCOMP %>%
    select(
      "Study ID" = lMapping[["dfSTUDCOMP"]][["strStudyCol"]],
      "Site ID" = lMapping[["dfSTUDCOMP"]][["strSiteCol"]],
      "Subject ID" = lMapping[["dfSTUDCOMP"]][["strIDCol"]],
      "Discontinuation Reason" = lMapping[["dfSTUDCOMP"]][["strStudyDiscontinuationReasonCol"]]
    ) %>%
    group_by(`Site ID`) %>%
    mutate(Enrolled = n()) %>%
    filter(!is.empty(`Discontinuation Reason`)) %>%
    group_by(`Site ID`, `Discontinuation Reason`) %>%
    mutate(Discontinued = n()) %>%
    ungroup() %>%
    mutate(`%` = pct(round(Discontinued/Enrolled * 100, digits = 2)))
}
