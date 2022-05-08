#' Protocol Deviation Assessment Mapping from Raw Data- Make Input Data
#'
#' @description
#' Convert raw protocol deviation (PD) data to formatted input data to {gsm::PD_Assess()}.
#'
#' @details
#' This function combines raw PD data with exposure data calculated by clindata::TimeOnStudy to create the required input for \code{\link{PD_Assess}}.
#'
#' @section Data Specification:
#' This function creates an input dataset for the Protocol Deviation (\code{\link{PD_Assess}}) by adding Protocol Deviation Counts to basic subject-level time on study data from `clindata::TimeOnStudy`.
#'
#' @param dfs list of data frames including:
#'   - `dfPD`  PD dataset with required column SUBJID and rows for each Protocol Deviation.
#'   - `dfSUBJ` Subject-level Raw Data required columns: SubjectID, SiteID, value specified in strTimeOnStudyCol.
#' @param lMapping List containing expected columns in each data set.
#' @param bReturnChecks Should input checks using `is_mapping_valid` be returned? Default is FALSE.
#' @param bQuiet Default is TRUE, which means warning messages are suppressed. Set to FALSE to see warning messages.
#'
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count, Exposure, Rate.
#'
#' @includeRmd ./man/md/PD_Map_Raw.md
#'
#' @examples
#' dfInput <- PD_Map_Raw() # Run with defaults
#' dfInput <- PD_Map_Raw(bReturnChecks = TRUE, bQuiet = FALSE) # Run with error checking and message log
#'
#' @import dplyr
#'
#' @export

PD_Map_Raw <- function(
  dfs = list(
    dfPD = clindata::rawplus_pd,
    dfSUBJ = clindata::rawplus_subj
  ),
  lMapping = clindata::mapping_rawplus,
  bReturnChecks = FALSE,
  bQuiet = TRUE
) {
  checks <- CheckInputs(
    context = "PD_Map_Raw",
    dfs = dfs,
    bQuiet = bQuiet,
    mapping = lMapping
  )

  # Run mapping if checks passed
  if (checks$status) {
    if (!bQuiet) cli::cli_h2("Initializing {.fn PD_Map_Raw}")

    # Standarize Column Names
    dfPD_mapped <- dfs$dfPD %>%
      select(SubjectID = lMapping[["dfPD"]][["strIDCol"]])

    dfSUBJ_mapped <- dfs$dfSUBJ %>%
      select(
        SubjectID = lMapping[["dfSUBJ"]][["strIDCol"]],
        SiteID = lMapping[["dfSUBJ"]][["strSiteCol"]],
        Exposure = lMapping[["dfSUBJ"]][["strTimeOnStudyCol"]]
      )

    # Create Subject Level PD Counts and merge Subj
    dfInput <- dfPD_mapped %>%
      group_by(.data$SubjectID) %>%
      summarize(Count = n()) %>%
      ungroup() %>%
      MergeSubjects(dfSUBJ_mapped, vFillZero = "Count", bQuiet = bQuiet) %>%
      mutate(Rate = .data$Count / .data$Exposure)

    if (!bQuiet) cli::cli_alert_success("{.fn AE_Map_Raw} returned output with {nrow(dfInput)} rows.")
  } else {
    if (!bQuiet) cli::cli_alert_warning("{.fn AE_Map_Raw} not run because of failed check.")
    dfInput <- NULL
  }

  if (bReturnChecks) {
    return(list(df = dfInput, lChecks = checks))
  } else {
    return(dfInput)
  }
}
