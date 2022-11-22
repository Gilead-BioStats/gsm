#' Query Rate - Raw Mapping
#'
#' @description
#' Convert raw query data to formatted input data to [gsm::QueryRate_Assess()].
#'
#' @details
#' `QueryRate_Map_Raw` combines query data with data points data and subject-level data to create
#' formatted input data to [gsm::QueryRate_Assess()]. This function creates an input dataset for the AE Assessment
#' ([gsm::QueryRate_Assess()]) by binding subject-level query counts (derived from `dfQuery`) and data point counts
#' (derived from `dfDataChg`) to subject-level data (from `dfSUBJ`). Note that the function can generate data summaries for specific types of
#' queries by passing filtered query data to `dfQuery`.
#'
#' @param dfs `list` Input data frames:
#'   - `dfSUBJ`: `data.frame` Subject-level data with one record per subject.
#'   - `dfQuery`: `data.frame` Query-level data with one record per query.
#'   - `dfDataChg`: `data.frame` Data-Point-level data with one record per data entry.
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name
#'   of the column.
#' @param bReturnChecks `logical` Return input checks from [gsm::is_mapping_valid()]? Default: `FALSE`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` Data frame with one record per subject, the input to [gsm::QueryRate_Assess()]. If
#' `bReturnChecks` is `TRUE` `QueryRate_Map_Raw` returns a named `list` with:
#' - `df`: the data frame described above
#' - `lChecks`: a named `list` of check results
#'
#' @includeRmd ./man/md/DataChg_Map_Raw.md
#'
#' @examples
#' # Run with defaults.
#' dfInput <- QueryRate_Map_Raw()
#'
#' # Run with error checking and message log.
#' dfInput <- QueryRate_Map_Raw(bReturnChecks = TRUE, bQuiet = FALSE)
#'
#' @importFrom cli cli_alert_success cli_alert_warning cli_h2
#' @import dplyr
#'
#' @export

QueryRate_Map_Raw <- function(
  dfs = list(
    dfSUBJ = clindata::rawplus_dm,
    dfQuery = clindata::edc_queries,
    dfDataChg = clindata::edc_data_change_rate
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
    context = "QueryRate_Map_Raw",
    dfs = dfs,
    bQuiet = bQuiet,
    mapping = lMapping
  )

  # Run mapping if checks passed.
  if (checks$status) {
    if (!bQuiet) cli::cli_h2("Initializing {.fn QueryRate_Map_Raw}")

    # Standarize Column Names
    dfQuery_mapped <- dfs$dfQuery %>%
      select(SubjectID = lMapping[["dfQuery"]][["strIDCol"]],
             VisitID = lMapping[["dfQuery"]][["strVisitCol"]],
             FormID = lMapping[["dfQuery"]][["strFormCol"]])

    dfDataChg_mapped <- dfs$dfDataChg %>%
      select(SubjectID = lMapping[["dfDataChg"]][["strIDCol"]],
             VisitID = lMapping[["dfDataChg"]][["strVisitCol"]],
             FormID = lMapping[["dfDataChg"]][["strFormCol"]],
             DataPoint = lMapping[["dfDataChg"]][["strDataPointsCol"]]) %>%
      mutate(DataPoint = as.numeric(.data$DataPoint, na.rm = TRUE))

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

    # Create Subject Level AE Counts and merge dfSUBJ
    dfInput <- dfSUBJ_mapped %>%
      left_join(
        dfQuery_mapped,
        "SubjectID"
      ) %>%
      group_by(.data$SubjectID) %>%
      mutate(Count= n()) %>%
      distinct(.data$SubjectID, .keep_all=TRUE) %>%
      ungroup() %>%
      left_join(
        dfDataChg_mapped,
        c("SubjectID", "VisitID", "FormID")) %>%
      mutate(
        Rate = .data$Count / .data$DataPoint
      ) %>%
      select(any_of(c(names(dfSUBJ_mapped))), "DataPoint", "Count", "Rate") %>%
      arrange(.data$SubjectID)

    if (!bQuiet) cli::cli_alert_success("{.fn QueryRate_Map_Raw} returned output with {nrow(dfInput)} rows.")
  } else {
    if (!bQuiet) cli::cli_alert_warning("{.fn QueryRate_Map_Raw} did not run because of failed check.")
    dfInput <- NULL
  }

  if (bReturnChecks) {
    return(list(df = dfInput, lChecks = checks))
  } else {
    return(dfInput)
  }
}
