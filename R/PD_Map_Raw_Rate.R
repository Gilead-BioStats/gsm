#' Protocol Deviation Assessment (Rate Outcome) - Raw Mapping
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
#' Convert raw protocol deviation (PD) data, typically processed case report form data, to formatted
#' input data to [gsm::PD_Assess_Rate()].
#'
#' @details
#' `PD_Map_Raw_Rate` combines PD data with subject-level study duration data to create formatted
#' input data to [gsm::PD_Assess_Rate()]. This function creates an input dataset for the PD Assessment
#' ([gsm::PD_Assess_Rate()]) by binding subject-level PD counts (derived from `dfPD`) to subject-level
#' data (from `dfSUBJ`). Note that the function can generate data summaries for specific types of
#' PDs by passing filtered PD data to `dfPD`.
#'
#' @param dfs `list` Input data frames:
#'   - `dfPD`: `data.frame` Event-level data with one record per PD.
#'   - `dfSUBJ`: `data.frame` Subject-level data with one record per subject.
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name
#'   of the column. Default: package-defined mapping for raw+.
#' @param bReturnChecks `logical` Return input checks from [gsm::is_mapping_valid()]? Default: `FALSE`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` Data frame with one record per subject, the input to [gsm::PD_Assess_Rate()]. If
#' `bReturnChecks` is `TRUE` `PD_Map_Raw_Rate` returns a named `list` with:
#' - `df`: the data frame described above
#' - `lChecks`: a named `list` of check results
#'
#' @includeRmd ./man/md/PD_Map_Raw.md
#'
#' @examples
#' # Run with defaults.
#' dfInput <- PD_Map_Raw_Rate()
#'
#' # Run with error checking and message log.
#' dfInput <- PD_Map_Raw_Rate(bReturnChecks = TRUE, bQuiet = FALSE)
#'
#' @importFrom cli cli_alert_success cli_alert_warning cli_h2
#' @importFrom yaml read_yaml
#'
#' @export

PD_Map_Raw_Rate <- function(
  dfs = list(
    dfSUBJ = clindata::rawplus_dm,
    dfPD = clindata::ctms_protdev
  ),
  lMapping = gsm::Read_Mapping(c("ctms", "rawplus")),
  bReturnChecks = FALSE,
  bQuiet = TRUE
) {
  stopifnot(
    "bReturnChecks must be logical" = is.logical(bReturnChecks),
    "bQuiet must be logical" = is.logical(bQuiet)
  )

  checks <- gsm::CheckInputs(
    context = "PD_Map_Raw_Rate",
    dfs = dfs,
    bQuiet = bQuiet,
    mapping = lMapping
  )

  # Run mapping if checks passed
  if (checks$status) {
    if (!bQuiet) cli::cli_h2("Initializing {.fn PD_Map_Raw_Rate}")

    # Standarize Column Names
    dfPD_mapped <- dfs$dfPD %>%
      select(SubjectID = lMapping[["dfPD"]][["strIDCol"]])

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
        Exposure = lMapping[["dfSUBJ"]][["strTimeOnStudyCol"]]
      )

    # Create Subject Level PD Counts and merge Subj
    dfInput <- dfPD_mapped %>%
      group_by(.data$SubjectID) %>%
      summarize(Count = n()) %>%
      ungroup() %>%
      gsm::MergeSubjects(dfSUBJ_mapped, vFillZero = "Count", vRemoval = "Exposure", bQuiet = bQuiet) %>%
      mutate(Rate = .data$Count / .data$Exposure) %>%
      select(any_of(names(dfSUBJ_mapped)), "Count", "Exposure", "Rate") %>%
      arrange(.data$SubjectID)

    if (!bQuiet) cli::cli_alert_success("{.fn PD_Map_Raw_Rate} returned output with {nrow(dfInput)} rows.")
  } else {
    if (!bQuiet) cli::cli_alert_warning("{.fn PD_Map_Raw_Rate} did not run because of failed check.")
    dfInput <- NULL
  }

  if (bReturnChecks) {
    return(list(df = dfInput, lChecks = checks))
  } else {
    return(dfInput)
  }
}
