#' Disposition Map
#'
#' Convert from ADaM or raw format to input format for Disposition Assessment.
#'
#' @section Data Specification:
#'
#' This function creates an input dataset for the Disposition Assessment (link to code) by adding Discontinuation Reason Counts to basic subject-level data.
#'
#'#' The following columns are required:
#'   - `SUBJID` - Unique subject ID
#'   - `SITEID` - Site ID
#'
#' @param dfDisp demographics data with the following required columns: SUBJID and SITEID.
#' @param strCol column name containing discontinuation reason.
#' @param strReason character vector of length 1 containing a single reason to run Disposisition Assessment on.
#'
#' @return Data frame with one record per person with columns: SubjectID, SiteID, Count, and the value passed to strCol.
#'
#' @import dplyr
#'
#' @export

Disp_Map <- function( dfDisp = NULL, strCol = NULL, strReason = "any") {

  stopifnot(
    is.data.frame(dfDisp),
    all(c("SUBJID", "SITEID") %in% names(dfDisp)),
    !is.null(strCol),
    length(strReason) == 1,
    nrow(dfDisp %>% group_by(.data$SUBJID) %>% filter(n() > 1)) == 0
  )

  dfInput <- dfDisp %>%
    select(SubjectID = .data$SUBJID,
           SiteID = .data$SITEID,
           strCol) %>%
    mutate(SubjectID = stringr::str_remove(.data$SubjectID, ".*-"),
           Count = case_when(strReason == "any" ~ 1,
                             tolower(.data[[strCol]]) == tolower(strReason) ~ 1,
                             TRUE ~ 0))

  return(dfInput)

}
