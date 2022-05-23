#' Protocol Deviation Assessment - Raw Mapping
#'
#' @description
#' Convert raw protocol deviation (PD) data, typically processed case report form data, to formatted
#' input data to {gsm::PD_Assess()}.
#'
#' @details
#' `PD_Map_Raw` combines PD data with subject-level treatment exposure data to create formatted
#' input data to {gsm::PD_Assess()}. This function creates an input dataset for the PD Assessment
#' ({gsm::PD_Assess()}) by binding subject-level PD counts (derived from `dfPD`) to subject-level
#' data (from `dfSUBJ`). Note that the function can generate data summaries for specific types of
#' PDs by passing filtered PD data to `dfPD`.
#'
#' @param dfs `list` Input data frames:
#'   - `dfPD`: `data.frame` Event-level data with one record per PD.
#'   - `dfSUBJ`: `data.frame` Subject-level data with one record per subject.
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key contains the name of the column.
#' @param bReturnChecks `logical` Return input checks from `is_mapping_valid`? Default: `FALSE`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` Data frame with one record per subject, the input to {gsm::PD_Assess()}. If
#' `bReturnChecks` is `TRUE` `PD_Map_Raw` returns a named `list` with:
#' - `df`: the data frame described above
#' - `lChecks`: a named `list` of check results
#'
#' @includeRmd ./man/md/PD_Map_Raw.md
#'
#' @examples
#' # Run with defaults
#' dfInput <- PD_Map_Raw()
#'
#' # Run with error checking and message log
#' dfInput <- PD_Map_Raw(bReturnChecks = TRUE, bQuiet = FALSE)
#'
#' @import dplyr
#'
#' @export

PD_Map_Raw <- function(
  dfs = list(
    dfPD = clindata::rawplus_pd,
    dfSUBJ = clindata::rawplus_subj
  ),
  lMapping = clindata::mapping_rawplus,
  bReturnChecks = FALSE,
  bQuiet = TRUE
) {
  checks <- CheckInputs(
    context = "PD_Map_Raw",
    dfs = dfs,
    bQuiet = bQuiet,
    mapping = lMapping
  )

  # Run mapping if checks passed
  if (checks$status) {
    if (!bQuiet) cli::cli_h2("Initializing {.fn PD_Map_Raw}")

    # Standarize Column Names
    dfPD_mapped <- dfs$dfPD %>%
      select(SubjectID = lMapping[["dfPD"]][["strIDCol"]])

    dfSUBJ_mapped <- dfs$dfSUBJ %>%
      select(
        SubjectID = lMapping[["dfSUBJ"]][["strIDCol"]],
        SiteID = lMapping[["dfSUBJ"]][["strSiteCol"]],
        Exposure = lMapping[["dfSUBJ"]][["strTimeOnStudyCol"]]
      )

    # Create Subject Level PD Counts and merge Subj
    dfInput <- dfPD_mapped %>%
      group_by(.data$SubjectID) %>%
      summarize(Count = n()) %>%
      ungroup() %>%
      gsm::MergeSubjects(dfSUBJ_mapped, vFillZero = "Count", bQuiet = bQuiet) %>%
      mutate(Rate = .data$Count / .data$Exposure) %>%
      select(.data$SubjectID, .data$SiteID, .data$Count, .data$Exposure, .data$Rate)

    if (!bQuiet) cli::cli_alert_success("{.fn PD_Map_Raw} returned output with {nrow(dfInput)} rows.")
  } else {
    if (!bQuiet) cli::cli_alert_warning("{.fn PD_Map_Raw} did not run because of failed check.")
    dfInput <- NULL
  }

  if (bReturnChecks) {
    return(list(df = dfInput, lChecks = checks))
  } else {
    return(dfInput)
  }
}
