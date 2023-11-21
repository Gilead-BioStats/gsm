#' `r lifecycle::badge("stable")`
#'
#' Query Rate Assessment - Raw Mapping
#'
#' @description
#' Convert raw query data to formatted input data to [gsm::QueryRate_Assess()].
#'
#' @details
#' `QueryRate_Map_Raw` combines query data with data points data and subject-level data to create
#' formatted input data to [gsm::QueryRate_Assess()]. This function creates an input dataset for the Query Rate Assessment
#' ([gsm::QueryRate_Assess()]) by binding subject-level query counts (derived from `dfQUERY`) and data point counts
#' (derived from `dfDATACHG`) to subject-level data (from `dfSUBJ`). Note that the function can generate data summaries for specific types of
#' queries by passing filtered query data to `dfQUERY`.
#'
#' @param dfs `list` Input data frames:
#'   - `dfSUBJ`: `data.frame` Subject-level data with one record per subject.
#'   - `dfQUERY`: `data.frame` Query-level data with one record per query.
#'   - `dfDATACHG`: `data.frame` Data-Point-level data with one record per data entry.
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
#' @importFrom yaml read_yaml
#' @import dplyr
#'
#' @export

QueryRate_Map_Raw <- function(
    dfs = gsm::UseClindata(
      list(
        "dfSUBJ" = "clindata::rawplus_dm",
        "dfQUERY" = "clindata::edc_queries",
        "dfDATACHG" = "clindata::edc_data_points"
      )
    ),
    lMapping = gsm::Read_Mapping(c("edc", "rawplus")),
    bReturnChecks = FALSE,
    bQuiet = TRUE) {
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



    dfQUERY_mapped <- dfs$dfQUERY %>%
      select(
        SubjectID = lMapping[["dfQUERY"]][["strIDCol"]],
        VisitID = lMapping[["dfQUERY"]][["strVisitCol"]],
        FormID = lMapping[["dfQUERY"]][["strFormCol"]]
      ) %>%
      group_by(.data$SubjectID, .data$VisitID, .data$FormID) %>%
      summarize(Count = n()) %>%
      ungroup()

    dfDATACHG_mapped <- dfs$dfDATACHG %>%
      select(
        SubjectID = lMapping[["dfDATACHG"]][["strIDCol"]],
        VisitID = lMapping[["dfDATACHG"]][["strVisitCol"]],
        FormID = lMapping[["dfDATACHG"]][["strFormCol"]]
      ) %>%
      group_by(.data$SubjectID, .data$VisitID, .data$FormID) %>%
      summarize(DataPoint = n()) %>%
      ungroup()

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

    # Create subject Level query and data point counts and merge dfSUBJ
    # Count query at Form level in dfQUERY to match with data points at Form level in dfDATACHG
    dfInput <- dfQUERY_mapped %>%
      full_join(
        dfDATACHG_mapped,
        c("SubjectID", "VisitID", "FormID")
      ) %>%
      group_by(.data$SubjectID) %>%
      summarize(
        Count = sum(.data$Count, na.rm = TRUE),
        DataPoint = sum(.data$DataPoint, na.rm = TRUE)
      ) %>%
      ungroup() %>%
      mutate(
        Count = tidyr::replace_na(.data$Count, 0),
        DataPoint = tidyr::replace_na(.data$DataPoint, 0)
      ) %>%
      gsm::MergeSubjects(
        dfSUBJ_mapped,
        vFillZero = "Count",
        vRemoval = "DataPoint",
        bQuiet = bQuiet
      ) %>%
      mutate(
        Rate = .data$Count / .data$DataPoint
      ) %>%
      select(any_of(c(names(dfSUBJ_mapped))), "Count", "DataPoint", "Rate") %>%
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
