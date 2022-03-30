##' LabAbnorm Assessment - Raw Mapping
#'
#' Convert Raw data, typically processed case report form data - to input format for Lab Abnormality Assessment.
#'
#' @details
#'
#' This function combines Lab data with treatment exposure from subject-level Raw Data (RDSL) to create the required input for \code{\link{LabAbnorm_Assess}}.
#'
#' @section Data Specification:
#'
#' This function creates an input dataset for the LabAbnorm Assessment (\code{\link{LabAbnorm_Assess}}) by adding LabAbnorm Event Counts to basic subject-level treatment exposure data from `clindata::TreatmentExposure`.
#'
#' The following columns are required:
#' - `dfLab`
#'     - `SUBJID` - Unique subject ID
#' - `dfRDSL`
#'     - `SubjectID` - Unique subject ID
#'     - `SiteID` - Site ID
#'     - Value specified in strExposureCol - Treatment Exposure in days; "TimeOnTreatment" by default
#'     
#' The following columns are Optional:
#' - `dfLab`
#'     - value specified in strTypeCol.
#'     - value specified in strFlagCol.
#'     
#' Note that the function can generate data summaries for specific types of Lab Abnormalities, but passing filtered Lab data to dfLab.
#'
#'
#' @param dfLab dfLab dataset with required column SUBJID and rows for each record
#' @param dfRDSL Subject-level Raw Data (RDSL) with required columns: SubjectID, SiteID, value specified in strExposureCol
#' @param mapping List containing expected columns in each data set. By default, mapping for dfLab is: `strIDCol` = "SUBJID". By default, mapping for dfRDSL is: `strIDCol` = "SubjectID", `strSiteCol` = "SiteID", and `strExposureCol` = "TimeOnTreatment". TODO: add more descriptive info or reference to mapping.
#' @param strTypeCol Name of `dfLab` column to key on. Default = NULL for no filtering.
#' @param strTypeValue Name values in strTypeCol to keep.  Default = NULL for no filtering.
#' @param strFlagCol Name of Flagging column. Default = NULL for no filtering.
#' @param strFlagValue value of strFlagCol to keep. Default = NULL for no filtering.
#'
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count (number of Lab records), Exposure (Time on Treatment in Days), Rate (Lab Record/Day)
#'
#' @examples
#'  
#'   
#'  dfRDSL <- clindata::rawplus_rdsl %>% dplyr::filter(!is.na(TimeOnTreatment))
#'  dfLab <-  clindata::rawplus_covlab_hema[1:10000,]  %>%
#'             dplyr::filter(.data$SUBJID != "")
#'
#'  dfInput <- LabAbnorm_Map_Raw(dfLab, dfRDSL)
#'
#'  dfInput <- LabAbnorm_Map_Raw(dfLab,
#'                               dfRDSL,
#'                               strTypeCol = 'LBTEST',
#'                               strTypeValue ="ALT (SGPT)",
#'                               strFlagCol = 'TOXFLG', 
#'                               strFlagValue = 1)
#' @import dplyr
#'
#' @export

LabAbnorm_Map_Raw <- function( dfLab, dfRDSL, mapping = NULL, strTypeCol = NULL,strTypeValue =  NULL, strFlagCol = NULL, strFlagValue = NULL   ){
  

  dfLab <- util_filter_df(dfLab,strTypeCol,strTypeValue )
  
  dfLab <- util_filter_df(dfLab,strFlagCol,strFlagValue )

    # Set defaults for mapping if none is provided
    if(is.null(mapping)){
      mapping <- list(
        dfLab = list(strIDCol="SUBJID"),
        dfRDSL = list(strIDCol="SubjectID", strSiteCol="SiteID", strExposureCol="TimeOnTreatment")
      )
    }
    
    # Check input data vs. mapping.
    is_lab_valid <- is_mapping_valid(
     dfLab,
      mapping$dfLab,
      vRequiredParams = c("strIDCol"),
      bQuiet = FALSE
    )
    
    is_rdsl_valid <- is_mapping_valid(
      dfRDSL,
      mapping$dfRDSL,
      vRequiredParams = c("strIDCol", "strSiteCol", "strExposureCol"),
      vUniqueCols = mapping$dfRDSL$strIDCol,
      bQuiet = FALSE
    )
    
    stopifnot(
      "Errors found in dfLab." = is_lab_valid$status,
      "Errors found in dfRDSL." = is_rdsl_valid$status
    )
    
    # Standarize Column Names
    dfLab_mapped <- dfLab %>%
      rename(SubjectID = mapping[["dfLab"]][["strIDCol"]]) %>%
      select(.data$SubjectID)
    
    dfRDSL_mapped <- dfRDSL %>%
      rename(
        SubjectID = mapping[["dfRDSL"]][["strIDCol"]],
        SiteID = mapping[["dfRDSL"]][["strSiteCol"]],
        Exposure = mapping[["dfRDSL"]][["strExposureCol"]]
      ) %>%
      select(.data$SubjectID, .data$SiteID, .data$Exposure)
    
    # Create Subject Level Lab Counts and merge RDSL
    dfInput <- dfLab_mapped %>%
      group_by(.data$SubjectID) %>%
      summarize(Count=n()) %>%
      ungroup() %>%
      mergeSubjects(dfRDSL_mapped, vFillZero="Count") %>%
      mutate(Rate = .data$Count/.data$Exposure) %>%
      select(.data$SubjectID,.data$SiteID, .data$Count, .data$Exposure, .data$Rate)
    

    return(dfInput)
}



