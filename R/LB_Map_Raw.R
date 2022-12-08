#' Lab Abnormality Assessment - Raw Mapping
#'
#' @description
#' Convert from ADaM or raw format to input format for Lab Abnormality Assessment.
#'
#' @details
#' Convert raw lab data (LB), typically processed case report form data, to formatted
#' input data to [gsm::LB_Assess()].
#'
#' `LB_Map_Raw` combines LB data with subject-level data to create formatted input data to
#' [gsm::LB_Assess()]. This function creates an input dataset for the LB Assessment
#' ([gsm::LB_Assess()]) by binding subject-level abnormal LB counts (derived from `dfLB`) to
#' subject-level data (from `dfSUBJ`). Note that the function can generate data summaries for
#' specific types of LB criteria by passing filtered LB data to `dfLB`.
#'
#' @param dfs `list` Input data frames:
#'  - `dfLB`: `data.frame` Lab data with one record subject per visit per lab result. Default: `clindata::rawplus_lb`
#'  - `dfSUBJ`: `data.frame` Subject-level data with one record per subject. Default: `clindata::rawplus_dm`
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name
#'   of the column. Default: package-defined mapping for raw+.
#' @param bReturnChecks `logical` Return input checks from [gsm::is_mapping_valid()]? Default: `FALSE`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` Data frame with one record per subject, the input to [gsm::LB_Assess()]. If
#' `bReturnChecks` is `TRUE` `LB_Map_Raw` returns a named `list` with:
#' - `df`: the data frame described above
#' - `lChecks`: a named `list` of check results
#'
#' @includeRmd ./man/md/LB_Map_Raw.md
#'
#' @examples
#' # Run with defaults.
#' dfInput <- LB_Map_Raw()
#'
#' # Run with error checking and message log.
#' dfInput <- LB_Map_Raw(bReturnChecks = TRUE, bQuiet = FALSE)
#'
#' @importFrom cli cli_alert_success cli_alert_warning cli_h2
#' @importFrom glue glue
#' @importFrom yaml read_yaml
#'
#' @export

LB_Map_Raw <- function(
  dfs = list(
    dfSUBJ = clindata::rawplus_dm,
    dfLB = clindata::rawplus_lb
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
    context = "LB_Map_Raw",
    dfs = dfs,
    bQuiet = bQuiet,
    mapping = lMapping
  )

  # Run mapping if checks passed.
  if (checks$status) {
    if (!bQuiet) cli::cli_h2("Initializing {.fn LB_Map_Raw}")

    # Standarize column names.
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

    dfLB_mapped <- dfs$dfLB %>%
      select(
        SubjectID = lMapping[["dfLB"]][["strIDCol"]],
        Grade = lMapping[["dfLB"]][["strGradeCol"]]
      )

    # Create subject Level LB counts and merge Subj
    dfInput <- dfLB_mapped %>%
      mutate(
        Count = if_else(
          .data$Grade %in% lMapping[["dfLB"]][["strGradeHighVal"]],
          1,
          0
        ),
        Total = 1
      ) %>%
      group_by(.data$SubjectID) %>%
      summarize(Count = sum(.data$Count, na.rm = TRUE),
                Total = sum(.data$Total, na.rm = TRUE)) %>%
      ungroup() %>%
      gsm::MergeSubjects(dfSUBJ_mapped, vFillZero = "Count", vRemoval = "Total", bQuiet = bQuiet) %>%
      select(any_of(c(names(dfSUBJ_mapped))), "Count", "Total") %>%
      arrange(.data$SubjectID)

    if (!bQuiet) cli::cli_alert_success("{.fn LB_Map_Raw} returned output with {nrow(dfInput)} rows.")
  } else {
    if (!bQuiet) cli::cli_alert_warning("{.fn LB_Map_Raw} did not run because of failed check.")
    dfInput <- NULL
  }

  if (bReturnChecks) {
    return(list(df = dfInput, lChecks = checks))
  } else {
    return(dfInput)
  }
}
