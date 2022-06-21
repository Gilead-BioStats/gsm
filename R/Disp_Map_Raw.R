#' Disposition Map
#'
#' Convert from ADaM or raw format to input format for Disposition Assessment.
#'
#' @description
#' `r lifecycle::badge("experimental")`
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
#' @return `data.frame` with one record per person with columns: SubjectID, SiteID, Count, and the value passed to strCol.
#'
#' @examples
#' df <- Disp_Map_Raw(strReason = "adverse event")
#'
#' @import dplyr
#' @importFrom yaml read_yaml
#'
#' @export

Disp_Map_Raw <- function(
    dfs = list(
      dfDISP = safetyData::adam_adsl
      ),
    strReason = "any",
    lMapping = yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
    bReturnChecks = FALSE,
    bQuiet = TRUE
) {
  stopifnot(
    "bReturnChecks must be logical" = is.logical(bReturnChecks),
    "bQuiet must be logical" = is.logical(bQuiet)
  )

  checks <- CheckInputs(
    context = "Disp_Map_Raw",
    dfs = dfs,
    bQuiet = bQuiet,
    mapping = lMapping
  )

  # Run mapping if checks passed.
  if (checks$status) {
    if (!bQuiet) cli::cli_h2("Initializing {.fn Disp_Map_Raw}")

  # Standarize Column Names
  dfDISP_mapped <- dfs$dfDISP %>%
    select(SubjectID = lMapping[["dfDISP"]][["strIDCol"]],
           SiteID = lMapping[["dfDISP"]][["strIDCol"]],
           Reason = lMapping[["dfDISP"]][["strDCCol"]]) %>%
    mutate(Reason = tolower(.data$Reason))

  strIgnore <- lMapping[["dfDISP"]][["strIgnoreVal"]]
  bIgnore <- lMapping[["dfDISP"]][["bIgnoreVal"]]
browser()
  dfInput <- dfDISP_mapped %>%
    mutate(Count = case_when(
      strReason == "any" & !(Reason %in% strIgnore | Reason %in% bIgnore) ~ 1,
      Reason == tolower(strReason) ~ 1,
      Reason %in% tolower(strIgnore) | Reason %in% bIgnore ~ 0,
      TRUE ~ 0
    ))

    if (!bQuiet) cli::cli_alert_success("{.fn Disp_Map_Raw} returned output with {nrow(dfInput)} rows.")
  } else {
    if (!bQuiet) cli::cli_alert_warning("{.fn Disp_Map_Raw} did not run because of failed check.")
    dfInput <- NULL
  }

  if (bReturnChecks) {
    return(list(df = dfInput, lChecks = checks))
  } else {
    return(dfInput)
  }
}
