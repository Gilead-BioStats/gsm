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
#' @param dfIE ie dataset with columns SUBJID and values specified in strCategoryCol and strValueCol.
#' @param dfSUBJ Subject-level Raw Data required columns: SubjectID SiteID
#' @param mapping List containing expected columns in each data set.
#' @param vCategoryValues Category values (of column in dfIE specified by strCategoryCol) Default =  c("Exclusion","Inclusion"). Category values must be in the same order as `vExpectedResultValues`.
#' @param vExpectedResultValues Vector containing expected values for the inclusion/exclusion criteria stored in dfIE$IEORRES. Defaults to c(0,1) where 0 is expected when dfIE$IECAT == "Exclusion" and 1 is expected when dfIE$IECAT=="Inclusion". Values must be in the same order as `vCategoryValues`.
#' @param bQuiet Default is TRUE, which means warning messages are suppressed. Set to FALSE to see warning messages.
#'
#' @return Data frame with one record per participant giving the number of inclusion/exclusion criteria the participant did not meet as expected. Expected columns: SubjectID, SiteID, Count
#'
#' @examples
#'
#' dfInput <- IE_Map_Raw(
#'    clindata::rawplus_ie,
#'    clindata::rawplus_subj
#')
#'
#' @import dplyr
#'
#' @export
IE_Map_Raw <- function(
    dfs=list(
      dfIE=clindata::rawplus_ie,
      dfSUBJ=clindata::rawplus_subj
    ),
    mapping = NULL,
    bReturnChecks = FALSE,
    bQuiet = TRUE
){

  if(is.null(mapping)) mapping <- yaml::read_yaml(system.file('mapping','rawplus.yaml', package = 'clindata')) # TODO remove

  # update in clindata
  mapping$dfIE$vCategoryValues <- c("EXCL", "INCL")
  mapping$dfIE$vExpectedResultValues <- c(0, 1)

  if(bReturnChecks){
    if(!bQuiet) cli::cli_h2("Checking Input Data for {.fn IE_Map_Raw}")
    checks <- CheckInputs(dfs = dfs, bQuiet = bQuiet, mapping = mapping, step = "mapping", yaml = "IE_Map_Raw.yaml")
    checks$status <- all(checks %>% map_lgl(~.x$status))
    run_mapping <- checks$status
  } else {
    run_mapping <- TRUE
  }

  if(run_mapping){
    if(!bQuiet) cli::cli_h2("Initializing {.fn IE_Map_Raw}")

    # Standarize Column Names
    dfSUBJ_mapped <- dfs$dfSUBJ %>%
      select(
        SubjectID = mapping[["dfSUBJ"]][["strIDCol"]],
        SiteID = mapping[["dfSUBJ"]][["strSiteCol"]]
      )

    dfIE_Subj <- dfs$dfIE %>%
      select(
        SubjectID = mapping[["dfIE"]][["strIDCol"]],
        category = mapping[["dfIE"]][["strCategoryCol"]],
        result = mapping[["dfIE"]][["strValueCol"]])

    # Create Subject Level IE Counts and merge Subj

    dfInput <- dfIE_Subj %>%
      mutate(
        expected = ifelse(
          .data$category == mapping$dfIE$vCategoryValues[1],
          mapping$dfIE$vExpectedResultValues[1],
          mapping$dfIE$vExpectedResultValues[2]
        ),
        valid = .data$result == .data$expected,
        invalid = .data$result != .data$expected,
        missing = !(.data$result %in% mapping$dfIE$vExpectedResultValues)
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
