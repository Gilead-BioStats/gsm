#' LabAbnorm Assessment - ADaM Mapping
#'
#' Convert from ADaM format to input format for Lab event Assessment.
#'
#' @details
#'
#' This function maps from ADaM ADSL and ADLB data to the required input for \code{\link{LabAbnorm_Assess}}.
#'
#' @section Data Specification:
#'
#' This function creates an input dataset for the Lab Measurements Assessment (\code{\link{LabAbnorm_Assess}}) by adding Lab Measurements Counts (from `dfADLB`) to basic subject-level data (from `dfADSL`).
#'
#' The following columns are required:
#' - `dfADSL`
#'   - `USUBJID` - Unique subject ID
#'   - `SITEID` - Site ID
#'   - `TRTEDT` - Treatment End date
#'   - `TRTSDT` - Treatment Start date
#' - `dfADLB`
#'    - `USUBJID` - Unique subject ID
#'
#' Note that the function can generate data summaries for specific types of Lab Measurements by passing filtered ADAE data to dfADAE.
#'
#' @param dfADSL ADaM demographics data with the following required columns:  USUBJID, SITEID, TRTEDT (end date), TRTSDT (start date)
#' @param dfADLB ADaM Lab data with the following required columns: USUBJID
#' @param mapping List containing expected columns in each data set. By default, mapping for dfADLB is: `strIDCol` = "SUBJID". By default, mapping for dfRDSL is: `strIDCol` = "SubjectID", `strSiteCol` = "SiteID", and `strExposureCol` = "TimeOnTreatment". TODO: add more descriptive info or reference to mapping.
#'
#'
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count (Number of Adverse Events), Exposure (Time on Treatment in Days), Rate (AEs/Day)
#'
#' @examples
#' dfInput <- LabAbnorm_Map_Adam( safetyData::adam_adsl, safetyData::adam_adlbc )
#'
#' @import dplyr
#'
#' @export

LabAbnorm_Map_Adam <- function( dfADSL, dfADLB, mapping = NULL ){
  
  # Set defaults for mapping if none is provided
  if(is.null(mapping)){
    mapping <- list(
      dfADSL = list(strIDCol="SUBJID", strSiteCol = "SITEID", strStartCol = "TRTSDT", strEndCol = "TRTEDT"),
      dfADLB = list(strIDCol="USUBJID")
    )
  }
  
  # Check input data vs. mapping.
  is_adsl_valid <- is_mapping_valid(
    dfADSL,
    mapping$dfADSL,
    vRequiredParams = c("strIDCol", "strSiteCol", "strStartCol", "strEndCol"),
    bQuiet = FALSE
  )
  
  is_adlb_valid <- is_mapping_valid(
    dfADLB,
    mapping$dfADLB,
    vRequiredParams = c("strIDCol"),
    vUniqueCols = mapping$dfRDSL$strIDCol,
    bQuiet = FALSE
  )
  
  stopifnot(
    "Errors found in dfADSL." = is_adsl_valid$status,
    "Errors found in dfADLB." = is_adlb_valid$status
  )
  
  
  
  
    # stopifnot(
    #   is.data.frame(dfADSL),
    #   is.data.frame(dfADLB),
    #   all(c("USUBJID", "SITEID", "TRTEDT", "TRTSDT") %in% names(dfADSL)),
    #   "USUBJID" %in% names(dfADLB),
    #   "NAs found in SUBJID column of dfADSL" = all(!is.na(dfADSL$USUBJID)),
    #   "NAs found in USUBJID column of dfADLB" = all(!is.na(dfADLB$USUBJID))
    # )
    
    dfInput <-  dfADSL %>%
      rename(SubjectID = .data$USUBJID) %>%
      rename(SiteID = .data$SITEID) %>%
      mutate(Exposure = as.numeric(.data$TRTEDT - .data$TRTSDT)+1) %>%
      rowwise() %>%
      mutate(Count =sum(dfADLB$USUBJID==.data$SubjectID)) %>%
      mutate(Rate = .data$Count/.data$Exposure) %>%
      select(.data$SubjectID,.data$SiteID, .data$Count, .data$Exposure, .data$Rate) %>%
      ungroup()
    return(dfInput)
}