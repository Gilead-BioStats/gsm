#' Inclusion/Exclusion Assessment Mapping from Raw Data- Make Input Data
#'
#' Convert from raw data format to needed input format for Inclusion/Exclusion Assessment.
#'
#' @details
#'
#' This function creates the required input for \code{\link{IE_Assess}}.
#'
#' @section Data Specification:
#'
#'
#' The following columns are required:
#' - `dfIE`
#'     - `SubjectID` - Unique subject ID
#'     - Value specified in `mapping` - IE Category; "IECAT_STD" by default
#'     - Value specified in `mapping` - Incl criteria not met Excl criteria met; "IEORRES" by default
#' - `dfSUBJ`
#'     - `SubjectID` - Unique subject ID
#'     - `SiteID` - Site ID
#'
#' @param dfs list of data frames including:
#'   - `dfIE` ie dataset with columns SUBJID and values specified in strCategoryCol and strValueCol.
#'   - `dfSUBJ` Subject-level Raw Data required columns: SubjectID SiteID
#' @param lMapping List containing expected columns in each data set.
#' @param bReturnChecks Should input checks using `is_mapping_valid` be returned? Default is FALSE.
#' @param bQuiet Default is TRUE, which means warning messages are suppressed. Set to FALSE to see warning messages.
#'
#' @return Data frame with one record per participant giving the number of inclusion/exclusion criteria the participant did not meet as expected. Expected columns: SubjectID, SiteID, Count
#'
#' @examples
#'
#' dfInput <- IE_Map_Raw() # Run with defaults
#' dfInput <- IE_Map_Raw(bReturnChecks=TRUE, bQuiet=FALSE) # Run with error checking and message log
#'
#' @import dplyr
#'
#' @export
IE_Map_Raw <- function(
    dfs=list(
      dfIE=clindata::rawplus_ie,
      dfSUBJ=clindata::rawplus_subj
    ),
    lMapping = clindata::mapping_rawplus,
    bReturnChecks = FALSE,
    bQuiet = TRUE
){

    checks <- CheckInputs(
      context = "IE_Map_Raw",
      dfs = dfs,
      bQuiet = bQuiet,
      mapping = lMapping
    )

    if(checks$status){
        if(!bQuiet) cli::cli_h2("Initializing {.fn IE_Map_Raw}")

        # Standarize Column Names
        dfSUBJ_mapped <- dfs$dfSUBJ %>%
          select(
            SubjectID = lMapping[["dfSUBJ"]][["strIDCol"]],
            SiteID = lMapping[["dfSUBJ"]][["strSiteCol"]]
          )

        dfIE_Subj <- dfs$dfIE %>%
          select(
            SubjectID = lMapping[["dfIE"]][["strIDCol"]],
            category = lMapping[["dfIE"]][["strCategoryCol"]],
            result = lMapping[["dfIE"]][["strValueCol"]])

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
          MergeSubjects(dfSUBJ_mapped, vFillZero="Count", bQuiet=bQuiet) %>%
          select(.data$SubjectID, .data$SiteID, .data$Count)

    if(!bQuiet) cli::cli_alert_success("{.fn IE_Map_Raw} returned output with {nrow(dfInput)} rows.")
  } else {
    if(!bQuiet) cli::cli_alert_warning("{.fn IE_Map_Raw} not run because of failed check.")
    dfInput <- NULL
  }

  if(bReturnChecks){
    return(list(dfInput=dfInput, lChecks=checks))
  }else{
    return(dfInput)
  }

}
