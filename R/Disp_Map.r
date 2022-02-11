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
#' @param strReason character vector containing a single reason, or comma-delimited list of reasons to run Disposisition Assessment on.
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
    !is.null(strCol)
  )
  # DCSREAS == "Completed"?
  dfInput <- dfDisp %>%
    filter(SAFFL == "Y" | !is.na(!!strCol)) %>%
    select(SubjectID = SUBJID,
           SiteID = SITEID,!!strCol) %>%
    mutate(SubjectID =  str_remove(SubjectID, ".*-"))


  if ("any" %in% tolower(strReason)) {
    dfInput <- dfInput %>%
      mutate(Count = 1)

  } else {
    dfInput <- dfInput %>%
      mutate(Count = ifelse(tolower(!!sym(strCol)) %in% tolower(strReason), 1, 0))

  }

  return(dfInput)

}
