#' Disposition Assessment - Raw Mapping
#'
#' Convert from ADaM or raw format to input format for Disposition Assessment.
#'
#' @description
#' Convert raw disposition data to formatted input data to #TODO: Disp_Assess()
#'
#' `r lifecycle::badge("experimental")`
#'
#' @details
#' `Disp_Map_Raw` creates an input dataset for the Disposition Assessment (link to code) by adding Discontinuation Reason Counts to basic subject-level data.
#'
#' @param dfs `list` Input data frame:
#'   - `dfDISP`: `data.frame` Subject-level data with one record per discontinuation reason.
#' @param strReason `character` Case-insensitive string value to describe the discontinuation reason, e.g., "adverse event".
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name
#'   of the column.
#' @param bReturnChecks `logical` Return input checks from [gsm::is_mapping_valid()]? Default: `FALSE`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` with one record per subject, the input to gsm::Disp_Assess(). If
#' `bReturnChecks` is `TRUE` `AE_Map_Raw` returns a named `list` with:
#' - `df`: the data frame described above
#' - `lChecks`: a named `list` of check results
#'
#' @includeRmd ./man/md/Disp_Map_Raw.md
#'
#' @examples
#' df <- Disp_Map_Raw(strReason = "adverse event")
#'
#' @import dplyr
#' @importFrom yaml read_yaml
#'
#' @export

Disp_Map_Raw <- function(
    dfs = list(
      dfDISP = clindata::rawplus_subj,
      dfSUBJ = clindata::rawplus_subj
      ),
    strReason = "any",
    lMapping = yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
    bReturnChecks = FALSE,
    bQuiet = TRUE
) {

  stopifnot(
    "bReturnChecks must be logical" = is.logical(bReturnChecks),
    "bQuiet must be logical" = is.logical(bQuiet)
  )

  checks <- CheckInputs(
    context = "Disp_Map_Raw",
    dfs = dfs,
    bQuiet = bQuiet,
    mapping = lMapping
  )

  # Run mapping if checks passed.
  if (checks$status) {
    if (!bQuiet) cli::cli_h2("Initializing {.fn Disp_Map_Raw}")

  # Standarize Column Names
  if(lMapping$dfDISP$strDiscontinuationScope == "Treatment") {

    dfDISP_mapped <- dfs$dfDISP %>%
      select(
        SubjectID = lMapping[["dfDISP"]][["strIDCol"]],
        TrtDCReason = lMapping[["dfDISP"]][["strTreatmentDiscontinuationReasonCol"]],
        TrtCompletion = lMapping[["dfDISP"]][["strTreatmentCompletionFlagCol"]]
      ) %>%
      filter(TrtCompletion != lMapping[["dfDISP"]][["strTreatmentCompletionFlagVal"]])

    if(!is.null(lMapping$dfDISP$strTreatmentDiscontinuationReasonVal)) {
      dfDISP_mapped <- dfDISP_mapped %>%
        filter(TrtDCReason == lMapping$dfDISP$strTreatmentDiscontinuationReasonVal)
    }

  } else if (lMapping$dfDISP$strDiscontinuationScope == "Study") {

    dfDISP_mapped <- dfs$dfDISP %>%
      select(
        SubjectID = lMapping[["dfDISP"]][["strIDCol"]],
        StudyDCReason = lMapping[["dfDISP"]][["strStudyDiscontinuationReasonCol"]],
        StudyCompletion = lMapping[["dfDISP"]][["strStudyCompletionFlagCol"]]
      ) %>%
      filter(StudyCompletion != lMapping[["dfDISP"]][["strStudyCompletionFlagVal"]])

    if(!is.null(lMapping$dfDISP$strStudyDiscontinuationReasonVal)) {
      dfDISP_mapped <- dfDISP_mapped %>%
        filter(TrtDCReason == lMapping$dfDISP$strStudyDiscontinuationReasonVal)
    }

  }

    dfSUBJ_mapped <- dfs$dfSUBJ %>%
      select(SubjectID = lMapping[["dfSUBJ"]][["strIDCol"]],
             SiteID = lMapping[["dfSUBJ"]][["strSiteCol"]])

    dfInput <- gsm::MergeSubjects(dfDomain = dfDISP_mapped,
                                  dfSubjects = dfSUBJ_mapped,
                                  bQuiet = bQuiet)

    if (!bQuiet) cli::cli_alert_success("{.fn Disp_Map_Raw} returned output with {nrow(dfInput)} rows.")
  } else {
    if (!bQuiet) cli::cli_alert_warning("{.fn Disp_Map_Raw} did not run because of failed check.")
    dfInput <- NULL
  }

  if (bReturnChecks) {
    return(list(df = dfInput, lChecks = checks))
  } else {
    return(dfInput)
  }
}
