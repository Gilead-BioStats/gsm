#' Inclusion/Exclusion Assessment - Raw Mapping
#'
#' @description
#' Convert raw inclusion/exclusion (IE) data, typically processed case report from data, to formatted
#' input data to {gsm::IE_Assess()}.
#'
#' @details
#' `IE_Map_Raw` combines IE data with subject-level data to create formatted input data to
#' {gsm::IE_Assess()}. This function creates an input dataset for the IE Assessment
#' (${gsm::IE_Assess()}) by binding subject-level unmet IE criteria counts (derived from `dfIE`) to
#' subject-level data (from `dfSUBJ`). Note that the function can generate data summaries for
#' specific types of IE criteria by passing filtered IE data to `dfIE`.
#'
#' @param dfs `list` Input data frames:
#'  - `dfIE`: `data.frame` Criterion-level data with one record subject per criterion.
#'  - `dfSUBJ`: `data.frame` Subject-level data with one record per subject.
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name of the column.
#' @param bReturnChecks `logical` Return input checks from {gsm::is_mapping_valid()}? Default: `FALSE`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` Data frame with one record per subject, the input to {gsm::IE_Assess()}. If
#' `bReturnChecks` is `TRUE` `IE_Map_Raw` returns a named `list` with:
#' - `df`: the data frame described above
#' - `lChecks`: a named `list` of check results
#'
#' @includeRmd ./man/md/IE_Map_Raw.md
#'
#' @examples
#' dfInput <- IE_Map_Raw() # Run with defaults
#' dfInput <- IE_Map_Raw(bReturnChecks = TRUE, bQuiet = FALSE) # Run with error checking and message log
#'
#' @import dplyr
#'
#' @export

IE_Map_Raw <- function(
  dfs = list(
    dfIE = clindata::rawplus_ie,
    dfSUBJ = clindata::rawplus_subj
  ),
  lMapping = clindata::mapping_rawplus,
  bReturnChecks = FALSE,
  bQuiet = TRUE
) {
  checks <- CheckInputs(
    context = "IE_Map_Raw",
    dfs = dfs,
    bQuiet = bQuiet,
    mapping = lMapping
  )

  if (checks$status) {
    if (!bQuiet) cli::cli_h2("Initializing {.fn IE_Map_Raw}")

    # Standarize column names.
    dfSUBJ_mapped <- dfs$dfSUBJ %>%
      select(
        SubjectID = lMapping[["dfSUBJ"]][["strIDCol"]],
        SiteID = lMapping[["dfSUBJ"]][["strSiteCol"]]
      )

    dfIE_Subj <- dfs$dfIE %>%
      select(
        SubjectID = lMapping[["dfIE"]][["strIDCol"]],
        category = lMapping[["dfIE"]][["strCategoryCol"]],
        result = lMapping[["dfIE"]][["strValueCol"]]
      )

    # Create Subject Level IE Counts and merge Subj
    dfInput <- dfIE_Subj %>%
      mutate(
        expected = ifelse(
          .data$category == lMapping$dfIE$vCategoryValues[1],
          lMapping$dfIE$vExpectedResultValues[1],
          lMapping$dfIE$vExpectedResultValues[2]
        ),
        valid = .data$result == .data$expected,
        invalid = .data$result != .data$expected,
        missing = !(.data$result %in% lMapping$dfIE$vExpectedResultValues)
      ) %>%
      group_by(.data$SubjectID) %>%
      summarise(
        Total = n(),
        Valid = sum(.data$valid),
        Invalid = sum(.data$invalid),
        Missing = sum(.data$missing)
      ) %>%
      mutate(Count = .data$Invalid + .data$Missing) %>%
      ungroup() %>%
      select(.data$SubjectID, .data$Count) %>%
      gsm::MergeSubjects(dfSUBJ_mapped, vFillZero = "Count", bQuiet = bQuiet) %>%
      select(.data$SubjectID, .data$SiteID, .data$Count)

    if (!bQuiet) cli::cli_alert_success("{.fn IE_Map_Raw} returned output with {nrow(dfInput)} rows.")
  } else {
    if (!bQuiet) cli::cli_alert_warning("{.fn IE_Map_Raw} did not run because of failed check.")
    dfInput <- NULL
  }

  if (bReturnChecks) {
    return(list(df = dfInput, lChecks = checks))
  } else {
    return(dfInput)
  }
}
