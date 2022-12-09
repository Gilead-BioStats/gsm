#' Screening Assessment - Raw Mapping
#'
#' @description
#' Convert raw screening data to formatted input data to [gsm::Screening_Assess()].
#'
#' @details
#' `Screening_Map_Raw` creates an input dataset for the Screening Assessment
#' [gsm::Screening_Assess()] by identifying Screen Failures (derived from `dfENROLL`).
#'
#' @param dfs `list` Input data frames:
#'   - `dfENROLL`: `data.frame` Subject-level study enrollment data with one record per subject. Default: `clindata::rawplus_enroll`
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
    dfENROLL = clindata::rawplus_enroll
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
    dfENROLL <- dfs$dfENROLL

    dfInput <- dfENROLL %>%
      select(
        any_of(
          c(
            StudyID = lMapping[["dfENROLL"]][["strStudyCol"]],
            SiteID = lMapping[["dfENROLL"]][["strSiteCol"]],
            CountryID = lMapping[["dfENROLL"]][["strCountryCol"]],
            CustomGroupID = lMapping[["dfENROLL"]][["strCustomGroupCol"]]
          )
        ),
        SubjectID = lMapping[["dfENROLL"]][["strIDCol"]],
        ScreenFail = lMapping[["dfENROLL"]][["strScreenFailCol"]],
        ScreenFailReason = lMapping[["dfENROLL"]][["strScreenFailReasonCol"]]
      ) %>%
      mutate(
        Count = as.numeric(
          .data$ScreenFail %in% lMapping[["dfENROLL"]][["strScreenFailVal"]]
        ),
        Total = 1
      ) %>%
      select(ends_with('ID'), 'Count', 'Total') %>%
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
