#' Data Entry Lag - Raw Mapping
#'
#' @description
#' Convert raw data entry data to formatted input data to [gsm::DataEntry_Assess()].
#'
#' @details
#' `DataEntry_Map_Raw` creates an input dataset for the Data Entry Lag Assessment [gsm::DataEntry_Assess()] by adding
#' Data Entry Lag Counts (derived from `dfDATAENT`) to basic subject-level data (from `dfSUBJ`).
#'
#' @param dfs `list` Input data frame:
#'   - `dfSUBJ`: `data.frame` Subject-level data with one record per participant.
#'   - `dfDATAENT`: `data.frame` Data-Point-level data with one record per data entry.
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name
#'   of the column.
#' @param bReturnChecks `logical` Return input checks from [gsm::is_mapping_valid()]? Default: `FALSE`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` with one record per subject, the input to [gsm::DataEntry_Assess()]. If
#' `bReturnChecks` is `TRUE` `DataEntry_Map_Raw` returns a named `list` with:
#' - `df`: the data frame described above
#' - `lChecks`: a named `list` of check results
#'
#' @includeRmd ./man/md/DataChg_Map_Raw.md
#'
#' @examples
#' # Run with defaults.
#' dfInput <- DataEntry_Map_Raw()
#'
#' # Run with error checking and message log.
#' dfInput <- DataEntry_Map_Raw(bReturnChecks = TRUE, bQuiet = FALSE)
#'
#' @importFrom cli cli_alert_success cli_alert_warning cli_h2
#' @importFrom glue glue
#' @importFrom yaml read_yaml
#' @import dplyr
#'
#' @export

DataEntry_Map_Raw <- function(
  dfs = list(
    dfSUBJ = clindata::rawplus_dm,
    dfDATAENT = clindata::edc_data_entry_lag
  ),
  lMapping = yaml::read_yaml(system.file("mappings", "mapping_edc.yaml", package = "gsm")),
  bReturnChecks = FALSE,
  bQuiet = TRUE
) {
  stopifnot(
    "bReturnChecks must be logical" = is.logical(bReturnChecks),
    "bQuiet must be logical" = is.logical(bQuiet)
  )

  checks <- CheckInputs(
    context = "DataEntry_Map_Raw",
    dfs = dfs,
    bQuiet = bQuiet,
    mapping = lMapping
  )

  # Run mapping if checks passed.
  if (checks$status) {
    if (!bQuiet) cli::cli_h2("Initializing {.fn DataEntry_Map_Raw}")

    # Standarize Column Names
    dfDATAENT_mapped <- dfs$dfDATAENT %>%
      select(SubjectID = lMapping[["dfDATAENT"]][["strIDCol"]],
             DataEntryLag = lMapping[["dfDATAENT"]][["strDataEntryLagCol"]])

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

    # Create subject Level data entry lag counts and merge dfSUBJ

    dfInput <- dfDATAENT_mapped %>%
      mutate(
        Count = if_else(
          .data$DataEntryLag %in% lMapping[["dfDATAENT"]][["strDataEntryLagVal"]],
          1,
          0
        ),
        Total = 1
      ) %>%
      group_by(.data$SubjectID) %>%
      summarize(Count = sum(.data$Count, na.rm = TRUE),
                Total = sum(.data$Total, na.rm = TRUE)) %>%
      ungroup() %>%
      gsm::MergeSubjects(dfSUBJ_mapped, vFillZero = "Count", bQuiet = bQuiet) %>%
      filter(!is.na(.data$Total)) %>%
      select(any_of(c(names(dfSUBJ_mapped))), "Count", "Total") %>%
      arrange(.data$SubjectID)

    if (!bQuiet) cli::cli_alert_success("{.fn DataEntry_Map_Raw} returned output with {nrow(dfInput)} rows.")
  } else {
    if (!bQuiet) cli::cli_alert_warning("{.fn DataEntry_Map_Raw} did not run because of failed check.")
    dfInput <- NULL
  }

  if (bReturnChecks) {
    return(list(df = dfInput, lChecks = checks))
  } else {
    return(dfInput)
  }
}
