#' AE Assessment - Raw Mapping
#'
#' @description
#' Convert raw adverse event (AE) data, typically processed case report form data, to formatted
#' input data to AE Assessment.
#'
#' @details
#' Combines AE data with subject-level treatment exposure data to create formatted input data to
#' \code{\link{AE_Assess}}. This function creates an input dataset for the AE Assessment
#' (\code{\link{AE_Assess}}) by binding subject-level adverse event counts (derived from `dfAE`) to
#' subject-level data (from `dfSUBJ`). Note that the function can generate data summaries for
#' specific types of AEs by passing filtered adverse event data to `dfAE`.
#'
#' @param dfs `list` Input data frames:
#'  - `dfAE`: `data.frame` One record per AE
#'  - `dfSUBJ`: `data.frame` One record per subject
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name of the column.
#' @param bReturnChecks `logical` Return input checks from `is_mapping_valid`? Default: `FALSE`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` Data frame with one record per subject, the input to [gsm::AE_Assess()]. If
#' `bReturnChecks` is `TRUE` `AE_Map_Raw` returns a named `list` with:
#' - `df`: the data frame described above
#' - `lChecks`: a named `list` of check results
#'
#' @includeRmd ./man/md/AE_Map_Raw.md
#'
#' @examples
#' dfInput <- AE_Map_Raw() # Run with defaults
#' dfInput <- AE_Map_Raw(bReturnChecks = TRUE, bQuiet = FALSE) # Run with error checking and message log
#'
#' @import dplyr
#'
#' @export

AE_Map_Raw <- function(dfs = list(
                         dfAE = clindata::rawplus_ae,
                         dfSUBJ = clindata::rawplus_subj
                       ),
                       lMapping = clindata::mapping_rawplus,
                       bReturnChecks = FALSE,
                       bQuiet = TRUE) {
  checks <- CheckInputs(
    context = "AE_Map_Raw",
    dfs = dfs,
    bQuiet = bQuiet,
    mapping = lMapping
  )

  # Run mapping if checks passed
  if (checks$status) {
    if (!bQuiet) cli::cli_h2("Initializing {.fn AE_Map_Raw}")

    # Standarize Column Names
    dfAE_mapped <- dfs$dfAE %>%
      select(SubjectID = lMapping[["dfAE"]][["strIDCol"]])

    dfSUBJ_mapped <- dfs$dfSUBJ %>%
      select(
        SubjectID = lMapping[["dfSUBJ"]][["strIDCol"]],
        SiteID = lMapping[["dfSUBJ"]][["strSiteCol"]],
        Exposure = lMapping[["dfSUBJ"]][["strTimeOnTreatmentCol"]]
      )

    # Create Subject Level AE Counts and merge dfSUBJ
    dfInput <- dfAE_mapped %>%
      group_by(.data$SubjectID) %>%
      summarize(Count = n()) %>%
      ungroup() %>%
      MergeSubjects(dfSUBJ_mapped, vFillZero = "Count", bQuiet = bQuiet) %>%
      mutate(Rate = .data$Count / .data$Exposure) %>%
      select(.data$SubjectID, .data$SiteID, .data$Count, .data$Exposure, .data$Rate)

    if (!bQuiet) cli::cli_alert_success("{.fn AE_Map_Raw} returned output with {nrow(dfInput)} rows.")
  } else {
    if (!bQuiet) cli::cli_alert_warning("{.fn AE_Map_Raw} not run because of failed check.")
    dfInput <- NULL
  }

  if (bReturnChecks) {
    return(list(df = dfInput, lChecks = checks))
  } else {
    return(dfInput)
  }
}
