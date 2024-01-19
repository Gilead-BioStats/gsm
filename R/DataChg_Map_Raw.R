#' Data Change Rate Assessment - Raw Mapping
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
#' Convert raw data entry data to formatted input data to [gsm::DataChg_Assess()].
#'
#' @details
#' `DataChg_Map_Raw` creates an input dataset for the Data Change Rate Assessment [gsm::DataChg_Assess()] by adding
#' Data Points with Change Counts (derived from `dfDATACHG`) to basic subject-level data (from `dfSUBJ`).
#'
#' @param dfs `list` Input data frame:
#'   - `dfSUBJ`: `data.frame` Subject-level data with one record per participant.
#'   - `dfDATACHG`: `data.frame` Data-Point-level data with one record per data entry.
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name
#'   of the column.
#' @param bReturnChecks `logical` Return input checks from [gsm::is_mapping_valid()]? Default: `FALSE`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` with one record per subject, the input to [gsm::DataChg_Assess()]. If
#' `bReturnChecks` is `TRUE` `DataChg_Map_Raw` returns a named `list` with:
#' - `df`: the data frame described above
#' - `lChecks`: a named `list` of check results
#'
#' @includeRmd ./man/md/DataChg_Map_Raw.md
#'
#' @examples
#' # Run with defaults.
#' dfInput <- DataChg_Map_Raw()
#'
#' # Run with error checking and message log.
#' dfInput <- DataChg_Map_Raw(bReturnChecks = TRUE, bQuiet = FALSE)
#'
#' @export

DataChg_Map_Raw <- function(
  dfs = gsm::UseClindata(
    list(
      "dfSUBJ" = "clindata::rawplus_dm",
      "dfDATACHG" = "clindata::edc_data_points"
    )
  ),
  lMapping = gsm::Read_Mapping(c("rawplus", "edc")),
  bReturnChecks = FALSE,
  bQuiet = TRUE) {
  stopifnot(
    "bReturnChecks must be logical" = is.logical(bReturnChecks),
    "bQuiet must be logical" = is.logical(bQuiet)
  )


  checks <- CheckInputs(
    context = "DataChg_Map_Raw",
    dfs = dfs,
    bQuiet = bQuiet,
    mapping = lMapping
  )

  # Run mapping if checks passed.
  if (checks$status) {
    if (!bQuiet) cli::cli_h2("Initializing {.fn DataChg_Map_Raw}")

    # Standarize Column Names
    dfDATACHG_mapped <- dfs$dfDATACHG %>%
      select(
        SubjectID = lMapping[["dfDATACHG"]][["strIDCol"]],
        DataChg = lMapping[["dfDATACHG"]][["strNChangesCol"]]
      ) %>%
      mutate(
        DataChg = as.numeric(.data$DataChg)
      )

    dfSUBJ_mapped <- dfs$dfSUBJ %>%
      select(
        SubjectID = lMapping[["dfSUBJ"]][["strEDCIDCol"]],
        any_of(
          c(
            SiteID = lMapping[["dfSUBJ"]][["strSiteCol"]],
            StudyID = lMapping[["dfSUBJ"]][["strStudyCol"]],
            CountryID = lMapping[["dfSUBJ"]][["strCountryCol"]],
            CustomGroupID = lMapping[["dfSUBJ"]][["strCustomGroupCol"]]
          )
        )
      )

    # Create subject Level data point with change counts and merge dfSUBJ
    dfInput <- dfDATACHG_mapped %>%
      group_by(.data$SubjectID) %>%
      summarize(
        Count = sum(.data$DataChg, na.rm = TRUE),
        Total = n()
      ) %>%
      ungroup() %>%
      gsm::MergeSubjects(dfSUBJ_mapped, vFillZero = "Count", vRemoval = "Total", bQuiet = bQuiet) %>%
      select(any_of(c(names(dfSUBJ_mapped))), "Count", "Total") %>%
      arrange(.data$SubjectID)

    if (!bQuiet) cli::cli_alert_success("{.fn DataChg_Map_Raw} returned output with {nrow(dfInput)} rows.")
  } else {
    if (!bQuiet) cli::cli_alert_warning("{.fn DataChg_Map_Raw} did not run because of failed check.")
    dfInput <- NULL
  }

  if (bReturnChecks) {
    return(list(df = dfInput, lChecks = checks))
  } else {
    return(dfInput)
  }
}
