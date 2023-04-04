#' `r lifecycle::badge("experimental")`
#'
#' Inclusion/Exclusion Assessment - Raw Mapping
#'
#' @description
#' Convert raw inclusion/exclusion (IE) data, typically processed case report form data, to formatted
#' input data to [gsm::IE_Assess()].
#'
#' @details
#' `IE_Map_Raw` combines IE data with subject-level data to create formatted input data to
#' [gsm::IE_Assess()]. This function creates an input dataset for the IE Assessment
#' ([gsm::IE_Assess()]) by binding subject-level unmet IE criteria counts (derived from `dfIE`) to
#' subject-level data (from `dfSUBJ`). Note that the function can generate data summaries for
#' specific types of IE criteria by passing filtered IE data to `dfIE`.
#'
#' @param dfs `list` Input data frames:
#'  - `dfIE`: `data.frame` Criterion-level data with one record subject per criterion. Default: `clindata::rawplus_ie`
#'  - `dfSUBJ`: `data.frame` Subject-level data with one record per subject. Default: `clindata::rawplus_dm`
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name
#'   of the column. Default: package-defined mapping for raw+.
#' @param bReturnChecks `logical` Return input checks from [gsm::is_mapping_valid()]? Default: `FALSE`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` Data frame with one record per subject, the input to [gsm::IE_Assess()]. If
#' `bReturnChecks` is `TRUE` `IE_Map_Raw` returns a named `list` with:
#' - `df`: the data frame described above
#' - `lChecks`: a named `list` of check results
#'
#' @includeRmd ./man/md/IE_Map_Raw.md
#'
#' @examples
#' # Run with defaults.
#' dfInput <- IE_Map_Raw()
#'
#' # Run with error checking and message log.
#' dfInput <- IE_Map_Raw(bReturnChecks = TRUE, bQuiet = FALSE)
#'
#' @importFrom cli cli_alert_success cli_alert_warning cli_h2
#' @importFrom yaml read_yaml
#'
#' @export

IE_Map_Raw <- function(
  dfs = list(
    dfSUBJ = clindata::rawplus_dm,
    dfIE = clindata::rawplus_ie
  ),
  lMapping = gsm::Read_Mapping("rawplus"),
  bReturnChecks = FALSE,
  bQuiet = TRUE
) {
  stopifnot(
    "bReturnChecks must be logical" = is.logical(bReturnChecks),
    "bQuiet must be logical" = is.logical(bQuiet)
  )

  checks <- gsm::CheckInputs(
    context = "IE_Map_Raw",
    dfs = dfs,
    bQuiet = bQuiet,
    mapping = lMapping
  )

  if (checks$status) {
    if (!bQuiet) cli::cli_h2("Initializing {.fn IE_Map_Raw}")

    # Standarize column names.
    dfIE_mapped <- dfs$dfIE %>%
      select(
        SubjectID = lMapping[["dfIE"]][["strIDCol"]],
        Category = lMapping[["dfIE"]][["strCategoryCol"]],
        Result = lMapping[["dfIE"]][["strResultCol"]]
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

    # Create Subject Level IE Counts and merge Subj
    dfInput <- dfIE_mapped %>%
      mutate(
        Expected = ifelse(
          .data$Category == lMapping$dfIE$strCategoryVal[1],
          lMapping$dfIE$strResultVal[1],
          lMapping$dfIE$strResultVal[2]
        ),
        Valid = .data$Result == .data$Expected,
        Invalid = .data$Result != .data$Expected,
        Missing = !(.data$Result %in% lMapping$dfIE$strResultVal)
      ) %>%
      group_by(.data$SubjectID) %>%
      summarise(
        Total = n(),
        Valid = sum(.data$Valid),
        Invalid = sum(.data$Invalid),
        Missing = sum(.data$Missing)
      ) %>%
      mutate(Count = .data$Invalid + .data$Missing) %>%
      ungroup() %>%
      select("SubjectID", "Count") %>%
      gsm::MergeSubjects(dfSUBJ_mapped, vFillZero = "Count", bQuiet = bQuiet) %>%
      select(any_of(names(dfSUBJ_mapped)), "Count") %>%
      arrange(.data$SubjectID)

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
