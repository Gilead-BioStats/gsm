#' Screening Assessment - Raw Mapping
#'
#' @description
#' Convert raw screening data to formatted input data to [gsm::Screening_Assess()].
#'
#' @details
#' `Screening_Map_Raw` creates an input dataset for the Screening Assessment
#' [gsm::Screening_Assess()] by adding Screen Failure Reason Counts (derived from `dfSCREENING`)
#' to basic subject-level data (from `dfSUBJ`).
#'
#' @param dfs `list` Input data frames:
#'   - `dfSUBJ`: `data.frame` Subject-level data with one record per participant. Default: `clindata::rawplus_dm`
#'   - `dfSCREENING`: `data.frame` Subject-level study screening data with one record per subject. Default: `clindata::rawplus_enroll`
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name
#'   of the column. Default: package-defined mapping for raw+.
#' @param bReturnChecks `logical` Return input checks from [gsm::is_mapping_valid()]? Default: `FALSE`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` with one record per subject, the input to [gsm::Screening_Assess()]. If
#' `bReturnChecks` is `TRUE` `Screening_Map_Raw` returns a named `list` with:
#' - `df`: the data frame described above
#' - `lChecks`: a named `list` of check results
#'
#' @includeRmd ./man/md/Screening_Map_Raw.md
#'
#' @examples
#' # Run with defaults.
#' dfInput <- Screening_Map_Raw()
#'
#' # Run with error checking and message log.
#' dfInput <- Screening_Map_Raw(bReturnChecks = TRUE, bQuiet = FALSE)
#'
#' @importFrom cli cli_alert_success cli_alert_warning cli_h2
#' @importFrom yaml read_yaml
#' @import dplyr
#'
#' @export

Screening_Map_Raw <- function(
  dfs = list(
    dfSUBJ = clindata::rawplus_dm,
    dfSCREENING = clindata::rawplus_enroll
  ),
  lMapping = yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
  bReturnChecks = FALSE,
  bQuiet = TRUE
) {
  stopifnot(
    "bReturnChecks must be logical" = is.logical(bReturnChecks),
    "bQuiet must be logical" = is.logical(bQuiet)
  )

  checks <- gsm::CheckInputs(
    context = "Screening_Map_Raw",
    dfs = dfs,
    bQuiet = bQuiet,
    mapping = lMapping
  )

  # Run mapping if checks passed.
  if (checks$status) {
    if (!bQuiet) cli::cli_h2("Initializing {.fn Screening_Map_Raw}")

    # Standarize Column Names
    dfSCREENING <- dfs$dfSCREENING

    dfSCREENING_mapped <- dfSCREENING %>%
      select(
        SubjectID = lMapping[["dfSCREENING"]][["strIDCol"]],
        SFReason = lMapping[["dfSCREENING"]][["strScreenFailureReasonCol"]],
        ScreenFailure = lMapping[["dfSCREENING"]][["strScreenFailureFlagCol"]]
      ) %>%
      filter(
        .data$ScreenFailure %in% lMapping[["dfSCREENING"]][["strScreenFailureFlagVal"]]
      ) %>%
      mutate(
        Count = 1
      )

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
        )
      )

    dfInput <- gsm::MergeSubjects(
      dfDomain = dfSCREENING_mapped,
      dfSUBJ = dfSUBJ_mapped,
      bQuiet = bQuiet
    ) %>%
      mutate(
        Count = ifelse(is.na(.data$Count), 0, .data$Count),
        Total = 1
      ) %>%
      select(any_of(names(dfSUBJ_mapped)), "Count", "Total") %>%
      arrange(.data$SubjectID)

    if (!bQuiet) cli::cli_alert_success("{.fn Screening_Map_Raw} returned output with {nrow(dfInput)} rows.")
  } else {
    if (!bQuiet) cli::cli_alert_warning("{.fn Screening_Map_Raw} did not run because of failed check.")
    dfInput <- NULL
  }

  if (bReturnChecks) {
    return(list(df = dfInput, lChecks = checks))
  } else {
    return(dfInput)
  }
}
