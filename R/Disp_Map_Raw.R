#' Disposition Assessment - Raw Mapping
#'
#' Convert from ADaM or raw format to input format for Disposition Assessment.
#'
#' @description
#' Convert raw disposition data to formatted input data to to formatted
#' input data to [gsm::Disp_Assess()].
#'
#' @details
#' `Disp_Map_Raw` creates an input dataset for the Disposition Assessment (link to code) by adding Discontinuation Reason Counts to basic subject-level data.
#'
#' @param dfs `list` Input data frame:
#'   - `dfDISP`: `data.frame` Subject-level data with one record per discontinuation reason.
#'   - `dfSUBJ`: `data.frame` Subject-level data with one record per participant.
#' @param strContext Disposition Context - "Treatment" or "Study"
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
#' df <- Disp_Map_Raw()
#'
#' @import dplyr
#' @importFrom yaml read_yaml
#' @importFrom glue glue
#'
#' @export

Disp_Map_Raw <- function(
    dfs = list(
      dfDISP = clindata::rawplus_subj,
      dfSUBJ = clindata::rawplus_subj
      ),
    strContext="Treatment",
    lMapping = yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
    bReturnChecks = FALSE,
    bQuiet = TRUE
) {

  stopifnot(
    "bReturnChecks must be logical" = is.logical(bReturnChecks),
    "bQuiet must be logical" = is.logical(bQuiet)
  )

  checks <- CheckInputs(
    context =  paste0("Disp_Map_Raw","_",strContext),
    dfs = dfs,
    bQuiet = bQuiet,
    mapping = lMapping
  )

  # Run mapping if checks passed.
  if (checks$status) {
    if (!bQuiet) cli::cli_h2("Initializing {.fn Disp_Map_Raw}")

  # Standarize Column Names
  dfDISP_mapped <- dfs$dfDISP %>%
    select(
      SubjectID = lMapping[["dfDISP"]][["strIDCol"]],
      DCReason = lMapping[["dfDISP"]][[glue('str{strContext}DiscontinuationReasonCol')]],
      Completion = lMapping[["dfDISP"]][[glue('str{strContext}CompletionFlagCol')]]
    ) %>%
    filter(.data$Completion != lMapping[["dfDISP"]][[glue::glue('str{strContext}CompletionFlagVal')]]) %>%
    mutate(Count = 1)


    dfSUBJ_mapped <- dfs$dfSUBJ %>%
      select(SubjectID = lMapping[["dfSUBJ"]][["strIDCol"]],
             SiteID = lMapping[["dfSUBJ"]][["strSiteCol"]])

    dfInput <- gsm::MergeSubjects(dfDomain = dfDISP_mapped,
                                  dfSubjects = dfSUBJ_mapped,
                                  bQuiet = bQuiet) %>%
      mutate(Count = ifelse(is.na(.data$Count), 0, .data$Count)) %>%
      select(.data$SubjectID, .data$SiteID, .data$Count)

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
