#' Consent Assessment - Raw Mapping
#'
#' @description
#' Convert raw informed consent data, typically processed case report from data, to formatted
#' input data to [gsm::Consent_Assess()].
#'
#' @details
#' `Consent_Map_Raw` combines consent data with subject-level data to create formatted input data
#' to [gsm::Consent_Assess()]. This function creates an input dataset for the Consent Assessment
#' (${Consent_Assess()} by binding subject-level counts of consent issues (derived from `dfCONSENT`) to
#' subject-level data (from `dfSUBJ`). Note the function can generate data summaries for specific
#' types of consent by customizing `lMapping$dfCONSENT`.
#'
#' @param dfs `list` Input data frames:
#'  - `dfCONSENT`: `data.frame` Consent type-level data with one record per subject per consent type.
#'  - `dfSUBJ`: `data.frame` Subject-level data with one record per subject.
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name
#'   of the column.
#' @param bReturnChecks `logical` Return input checks from [gsm::is_mapping_valid()]? Default: `FALSE`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` Data frame with one record per subject, the input to [gsm::Consent_Assess()].
#' If `bReturnChecks` is `TRUE` `Consent_Map_Raw` returns a named `list` with:
#' - `df`: the data frame described above
#' - `lChecks`: a named `list` of check results
#'
#' @includeRmd ./man/md/Consent_Map_Raw.md
#'
#' @examples
#' # Run with defaults.
#' dfInput <- Consent_Map_Raw()
#'
#' # Run with error checking and message log.
#' dfInput <- Consent_Map_Raw(bReturnChecks = TRUE, bQuiet = FALSE)
#'
#' @importFrom cli cli_alert_success cli_alert_warning cli_h2
#' @import dplyr
#'
#' @export

Consent_Map_Raw <- function(
  dfs = list(
    dfCONSENT = clindata::rawplus_consent,
    dfSUBJ = clindata::rawplus_subj
  ),
  lMapping = yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
  bReturnChecks = FALSE,
  bQuiet = TRUE
) {
  stopifnot(
    "bReturnChecks must be logical" = is.logical(bReturnChecks),
    "bQuiet must be logical" = is.logical(bQuiet)
  )

  checks <- CheckInputs(
    context = "Consent_Map_Raw",
    dfs = dfs,
    bQuiet = bQuiet,
    mapping = lMapping
  )

  if (checks$status) {
    if (!bQuiet) cli::cli_h2("Initializing {.fn Consent_Map_Raw}")

    # Standarize column names.
    dfCONSENT_mapped <- dfs$dfCONSENT %>%
      select(
        SubjectID = lMapping[["dfCONSENT"]][["strIDCol"]],
        ConsentType = lMapping[["dfCONSENT"]][["strTypeCol"]],
        ConsentStatus = lMapping[["dfCONSENT"]][["strValueCol"]],
        ConsentDate = lMapping[["dfCONSENT"]][["strDateCol"]]
      )

    dfSUBJ_mapped <- dfs$dfSUBJ %>%
      select(SubjectID = lMapping[["dfSUBJ"]][["strIDCol"]],
             any_of(
               c(
                 SiteID = lMapping[["dfSUBJ"]][["strSiteCol"]],
                 StudyID = lMapping[["dfSUBJ"]][["strStudyCol"]],
                 CustomGroupID = lMapping[["dfSUBJ"]][["strCustomGroupCol"]]
               )
             ),
             RandDate = lMapping[["dfSUBJ"]][["strRandDateCol"]])

    if (!is.null(lMapping$dfCONSENT$strConsentTypeValue)) {
      dfCONSENT_mapped <- dfCONSENT_mapped %>%
        filter(
          .data$ConsentType == lMapping$dfCONSENT$strConsentTypeValue
        )

      if (nrow(dfCONSENT_mapped) == 0) {
        stop(paste0(
          "No records in [ dfs$dfCONSENT$",
          lMapping$dfCONSENT$strTypeCol,
          " ] contain a consent type of [ ",
          lMapping$dfCONSENT$strConsentTypeValue,
          " ]."
        ))
      }
    }

    dfInput <- dfCONSENT_mapped %>%
      gsm::MergeSubjects(dfSUBJ_mapped, bQuiet = bQuiet) %>%
      mutate(
        flag_noconsent = .data$ConsentStatus != lMapping$dfCONSENT$strConsentStatusValue,
        flag_missing_consent = is.na(.data$ConsentDate),
        flag_missing_rand = is.na(.data$RandDate),
        flag_date_compare = .data$ConsentDate >= .data$RandDate,
        any_flag = .data$flag_noconsent | .data$flag_missing_consent | .data$flag_missing_rand | .data$flag_date_compare,
        Count = as.numeric(.data$any_flag, na.rm = TRUE)
      ) %>%
      select(any_of(c(names(dfSUBJ_mapped))), .data$Count)

    if (!bQuiet) cli::cli_alert_success("{.fn Consent_Map_Raw} returned output with {nrow(dfInput)} rows.")
  } else {
    if (!bQuiet) cli::cli_alert_warning("{.fn Consent_Map_Raw} did not run because of failed check.")
    dfInput <- NULL
  }


  if (bReturnChecks) {
    return(list(df = dfInput, lChecks = checks))
  } else {
    return(dfInput)
  }
}
