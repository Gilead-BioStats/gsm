#' Disposition Map
#'
#' Convert from ADaM or raw format to input format for Disposition Assessment.
#'
#' @section Data Specification:
#'
#' This function creates an input dataset for the Disposition Assessment (link to code) by adding Discontinuation Reason Counts to basic subject-level data.
#'
#' The following columns are required:
#'   - `SUBJID` - Unique subject ID
#'   - `SITEID` - Site ID
#'
#' @param dfDisp disposition data with the following required columns: SUBJID and SITEID. Must also include the value specified in the `strCol` parameter.
#' @param strCol column name containing discontinuation reason.
#' @param strReason character string containing reason for discontinuation. Can be a value found in `dfDisp$strCol` or "any" (the default), which selects all reasons not included in `vReasonIgnore`
#' @param vReasonIgnore character vector containing reasons to ignore when counting Discontinuation Reason (i.e., "Completed", "", etc.)
#'
#' @return Data frame with one record per person with columns: SubjectID, SiteID, Count, and the value passed to strCol.
#'
#' #' @examples
#' df <- Disp_Map(dfDisp = safetyData::adam_adsl, strCol = "DCREASCD", strReason = "adverse event")
#'
#' @import dplyr
#'
#' @export

Disp_Map <- function( dfDisp, strCol, strReason = "any", vReasonIgnore = c("", " ", "completed", NA)) {

  stopifnot(
    "dfDisp is not a data.frame" = is.data.frame(dfDisp),
    "One or both of these columns: SUBJID, SITEID not found in dfDisp" = all(c("SUBJID", "SITEID") %in% names(dfDisp)),
    "strCol is not character" = is.character(strCol),
    "strReason must be length 1" = length(strReason) == 1,
    "Duplicate SUBJID found in dfDisp" = nrow(dfDisp %>% group_by(.data$SUBJID) %>% filter(n() > 1)) == 0,
    "strReason cannot also be in vReasonIgnore" = !tolower(strReason) %in% tolower(vReasonIgnore),
    "strCol must exist in dfDisp" = strCol %in% names(dfDisp)
  )

  dfInput <- dfDisp %>%
    select(SubjectID = .data$SUBJID,
           SiteID = .data$SITEID,
           strCol) %>%
    mutate(Count = case_when(
             tolower(strReason) == "any" &  !(tolower(.data[[strCol]]) %in% tolower(vReasonIgnore)) ~ 1,
             tolower(.data[[strCol]]) == tolower(strReason) ~ 1,
             tolower(.data[[strCol]]) %in% tolower(vReasonIgnore) ~ 0,
             TRUE ~ 0))

  return(dfInput)

}
