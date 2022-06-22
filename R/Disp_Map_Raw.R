#' Disposition Assessment - Raw Mapping
#'
#' Convert from ADaM or raw format to input format for Disposition Assessment.
#'
#' @description
#' Convert raw disposition data to formatted input data to #TODO: Disp_Assess()
#'
#' `r lifecycle::badge("experimental")`
#'
#' @details
#' `Disp_Map_Raw` creates an input dataset for the Disposition Assessment (link to code) by adding Discontinuation Reason Counts to basic subject-level data.
#'
#' @param dfs `list` Input data frame:
#'   - `dfDISP`: `data.frame` Subject-level data with one record per discontinuation reason.
#' @param strReason `character` Case-insensitive string value to describe the discontinuation reason, e.g., "adverse event".
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name
#'   of the column.
#' @param bReturnChecks `logical` Return input checks from [gsm::is_mapping_valid()]? Default: `FALSE`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` with one record per subject, the input to gsm::Disp_Assess(). If
#' `bReturnChecks` is `TRUE` `AE_Map_Raw` returns a named `list` with:
#' - `df`: the data frame described above
#' - `lChecks`: a named `list` of check results
#'
#' @includeRmd ./man/md/Disp_Map_Raw.md
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

  strIgnore <- lMapping[["dfDISP"]][["strIgnoreVal"]]
  bIgnore <- as.logical(lMapping[["dfDISP"]][["bIgnoreVal"]])

  stopifnot(
    "bReturnChecks must be logical" = is.logical(bReturnChecks),
    "bQuiet must be logical" = is.logical(bQuiet),
    "strReason cannot also be a value in strIgnoreVal" = !tolower(strReason) %in% strIgnore,
    "strReason must be length 1" = length(strReason) == 1,
    "strReason must be character" = is.character(strReason)
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
           SiteID = lMapping[["dfDISP"]][["strSiteCol"]],
           Reason = lMapping[["dfDISP"]][["strDCCol"]]) %>%
    mutate(Reason = tolower(.data$Reason))

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
