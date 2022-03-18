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
#' @param mapping List containing expected columns in each data set.
#' @param strReason character string containing reason for discontinuation. Can be a value found in `dfDisp$strCol` or "any" (the default), which selects all reasons not included in `vReasonIgnore`
#' @param vReasonIgnore character vector containing reasons to ignore when counting Discontinuation Reason (i.e., "Completed", "", etc.)
#'
#' @return Data frame with one record per person with columns: SubjectID, SiteID, Count, and the value passed to strCol.
#'
#' @examples
#' df <- Disp_Map(dfDisp = safetyData::adam_adsl, strReason = "adverse event")
#'
#' @import dplyr
#'
#' @export

Disp_Map <- function( dfDisp, mapping = NULL, strReason = "any", vReasonIgnore = c("", " ", "completed", NA)) {

  # Set defaults for mapping if none is provided
  if(is.null(mapping)){
    mapping <- list(
      dfDisp = list(strIDCol="SUBJID", strSiteCol = "SITEID", strDispCol = "DCREASCD")
    )
  }

  # Check input data vs. mapping.
  is_disp_valid <- is_mapping_valid(
    dfDisp,
    mapping$dfDisp,
    vRequiredParams = c("strIDCol", "strSiteCol", "strDispCol"),
    vUniqueCols = mapping$dfDisp$strIDCol,
    bQuiet = FALSE
  )

  stopifnot(
    "Errors found in dfDisp" = is_disp_valid$status,
    "strReason must be length 1" = length(strReason) == 1,
    "strReason cannot also be in vReasonIgnore" = !tolower(strReason) %in% tolower(vReasonIgnore)
  )

  strDispCol <- mapping[["dfDisp"]][["strDispCol"]]

  dfInput <- dfDisp %>%
    select(SubjectID = mapping[["dfDisp"]][["strIDCol"]],
           SiteID = mapping[["dfDisp"]][["strSiteCol"]],
           strDispCol) %>%
    mutate(Count = case_when(
             tolower(strReason) == "any" &  !(tolower(.data[[strDispCol]]) %in% tolower(vReasonIgnore)) ~ 1,
             tolower(.data[[strDispCol]]) == tolower(strReason) ~ 1,
             tolower(.data[[strDispCol]]) %in% tolower(vReasonIgnore) ~ 0,
             TRUE ~ 0))

  return(dfInput)

}
