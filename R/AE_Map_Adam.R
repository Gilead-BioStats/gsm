#' `r lifecycle::badge("experimental")`
#'
#' Adverse Event Assessment - ADaM Mapping
#'
#' @description
#' Convert analysis adverse event (AE) data, by default ADaM data, to formatted input data to
#' [gsm::AE_Assess()].
#'
#' @details
#' `AE_Map_Adam` combines AE data with subject-level treatment exposure data to create formatted
#' input data to [gsm::AE_Assess()]. This function creates an input dataset for the AE Assessment
#' ([gsm::AE_Assess()]) by binding subject-level AE counts (derived from `dfADAE`) to subject-level
#' data (from `dfADSL`). Note that the function can generate data summaries for specific types of
#' AEs by passing filtered AE data to `dfADAE`.
#'
#' @param dfs `list` Input data frames:
#'  - `dfADAE`: `data.frame` Event-level data with one record per AE. Default: `safetyData::adam_adsl`
#'  - `dfADSL`: `data.frame` Subject-level data with one record per subject. Default: `safetyData::adam_adae`
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name of the column. Default: package-defined mapping for ADaM.
#' @param bReturnChecks `logical` Return input checks from [gsm::is_mapping_valid()]? Default: `FALSE`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` Data frame with one record per subject, the input to [gsm::AE_Assess()]. If
#' `bReturnChecks` is `TRUE` `AE_Map_Adam` returns a named `list` with:
#' - `df`: the data frame described above
#' - `lChecks`: a named `list` of check results
#'
#' @includeRmd ./man/md/AE_Map_Adam.md
#'
#' @examples
#' # Run with defaults
#' dfInput <- AE_Map_Adam()
#'
#' # Run with error checking and message log
#' dfInput <- AE_Map_Adam(bReturnChecks = TRUE, bQuiet = FALSE)
#'
#' @importFrom cli cli_alert_success cli_alert_warning cli_h2
#' @importFrom yaml read_yaml
#' @import dplyr
#'
#' @export

AE_Map_Adam <- function(
  dfs = list(
    dfADSL = safetyData::adam_adsl,
    dfADAE = safetyData::adam_adae
  ),
  lMapping = yaml::read_yaml(system.file("mappings", "mapping_adam.yaml", package = "gsm")),
  bReturnChecks = FALSE,
  bQuiet = TRUE
) {
  stopifnot(
    "bReturnChecks must be logical" = is.logical(bReturnChecks),
    "bQuiet must be logical" = is.logical(bQuiet)
  )

  checks <- CheckInputs(
    context = "AE_Map_Adam",
    dfs = dfs,
    bQuiet = bQuiet,
    mapping = lMapping
  )

  if (is.null(lMapping)) {
    lMapping <- checks$mapping
  }

  # Run mapping if checks passed.
  if (checks$status) {
    if (!bQuiet) cli::cli_h2("Initializing {.fn AE_Map_Adam}")

    dfInput <- dfs$dfADSL %>%
      mutate(
        SubjectID = .data[[lMapping$dfADSL$strIDCol]],
        Exposure = as.numeric(.data[[lMapping$dfADSL$strEndCol]] - .data[[lMapping$dfADSL$strStartCol]]) + 1
      ) %>%
      rowwise() %>%
      mutate(
        Count = sum(dfs$dfADAE[[lMapping$dfADAE$strIDCol]] == .data$SubjectID),
        Rate = .data$Count / .data$Exposure
      ) %>%
      ungroup() %>%
      select(
        "SubjectID",
        any_of(c(
          SiteID = lMapping[["dfADSL"]][["strSiteCol"]],
          StudyID = lMapping[["dfADSL"]][["strStudyCol"]],
          CountryID = lMapping[["dfADSL"]][["strCountryCol"]],
          CustomGroupID = lMapping[["dfADSL"]][["strCustomGroupCol"]]
        )),
        "Count",
        "Exposure",
        "Rate"
      ) %>%
      arrange(.data$SubjectID)

    if (!bQuiet) cli::cli_alert_success("{.fn AE_Map_Adam} returned output with {nrow(dfInput)} rows.")
  } else {
    if (!bQuiet) cli::cli_alert_warning("{.fn AE_Map_Adam} did not run because of failed check.")
    dfInput <- NULL
  }

  if (bReturnChecks) {
    return(list(df = dfInput, lChecks = checks))
  } else {
    return(dfInput)
  }
}
