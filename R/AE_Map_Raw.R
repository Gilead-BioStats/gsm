#' Adverse Event Assessment - Raw Mapping
#'
#' @description
#' Convert raw adverse event (AE) data, typically processed case report form data, to formatted
#' input data to [gsm::AE_Assess()].
#'
#' @details
#' `AE_Map_Raw` combines AE data with subject-level treatment exposure data to create formatted
#' input data to [gsm::AE_Assess()]. This function creates an input dataset for the AE Assessment
#' ([gsm::AE_Assess()]) by binding subject-level AE counts (derived from `dfAE`) to subject-level
#' data (from `dfSUBJ`). Note that the function can generate data summaries for specific types of
#' AEs by passing filtered AE data to `dfAE`.
#'
#' @param dfs `list` Input data frames:
#'   - `dfAE`: `data.frame` Event-level data with one record per AE. Default: `clindata::rawplus_ae`
#'   - `dfSUBJ`: `data.frame` Subject-level data with one record per subject. Default: `clindata::rawplus_dm`
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name
#'   of the column. Default: package-defined mapping for raw+.
#' @param bReturnChecks `logical` Return input checks from [gsm::is_mapping_valid()]? Default: `FALSE`
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
#' # Run with defaults.
#' dfInput <- AE_Map_Raw()
#'
#' # Run with error checking and message log.
#' dfInput <- AE_Map_Raw(bReturnChecks = TRUE, bQuiet = FALSE)
#'
#' @importFrom cli cli_alert_success cli_alert_warning cli_h2
#' @importFrom yaml read_yaml
#' @import dplyr
#'
#' @export

AE_Map_Raw <- function(
  dfs = list(
    dfSUBJ = clindata::rawplus_dm,
    dfAE = clindata::rawplus_ae
  ),
  lMapping = yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
  bReturnChecks = FALSE,
  bQuiet = TRUE
) {
  stopifnot(
    "bReturnChecks must be logical" = is.logical(bReturnChecks),
    "bQuiet must be logical" = is.logical(bQuiet)
  )

  checks <- CheckInputs(
    context = "AE_Map_Raw",
    dfs = dfs,
    bQuiet = bQuiet,
    mapping = lMapping
  )

  # Run mapping if checks passed.
  if (checks$status) {
    if (!bQuiet) cli::cli_h2("Initializing {.fn AE_Map_Raw}")

    # Standarize Column Names
    dfAE_mapped <- dfs$dfAE %>%
      select(SubjectID = lMapping[["dfAE"]][["strIDCol"]])

    dfSUBJ_mapped <- dfs$dfSUBJ %>%
      select(
        SubjectID = lMapping[["dfSUBJ"]][["strIDCol"]],
        any_of(
          c(
            SiteID = lMapping[["dfSUBJ"]][["strSiteCol"]],
            StudyID = lMapping[["dfSUBJ"]][["strStudyCol"]],
            CountryID = lMapping[["dfSUBJ"]][["strCountryCol"]],
            CustomGroupID = lMapping[["dfSUBJ"]][["strCustomGroupCol"]]
          )
        ),
        Exposure = lMapping[["dfSUBJ"]][["strTimeOnTreatmentCol"]]
      )

    # Create Subject Level AE Counts and merge dfSUBJ
    dfInput <- dfAE_mapped %>%
      group_by(.data$SubjectID) %>%
      summarize(Count = n()) %>%
      ungroup() %>%
      gsm::MergeSubjects(dfSUBJ_mapped, vFillZero = "Count", vRemoval = "Exposure", bQuiet = bQuiet) %>%
      mutate(Rate = .data$Count / .data$Exposure) %>%
      select(any_of(c(names(dfSUBJ_mapped))), "Count", "Rate") %>%
      arrange(.data$SubjectID)

    if (!bQuiet) cli::cli_alert_success("{.fn AE_Map_Raw} returned output with {nrow(dfInput)} rows.")
  } else {
    if (!bQuiet) cli::cli_alert_warning("{.fn AE_Map_Raw} did not run because of failed check.")
    dfInput <- NULL
  }

  if (bReturnChecks) {
    return(list(df = dfInput, lChecks = checks))
  } else {
    return(dfInput)
  }
}
