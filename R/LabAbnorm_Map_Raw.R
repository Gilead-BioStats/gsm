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
#' This function creates an input dataset for the Adverse Event Assessment (\code{\link{LabAbnorm_Assess}}) by adding Adverse Event Counts to basic subject-level treatment exposure data from `clindata::TreatmentExposure`.
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
#' @param dfLab dfLab dataset with required column SUBJID and rows for each AE record
#' @param dfRDSL Subject-level Raw Data (RDSL) with required columns: SubjectID, SiteID, value specified in strExposureCol
#' @param strExposureCol Name of exposure column. 'TimeOnTreatment' by default
#' @param strTypeCol Name dfLab colum to key on. Default = NULL for no filtering.
#' @param strTypeValue Name values in strTypeCol to keep.  Default = NULL for no filtering.
#' @param strFlagCol Name of Flagging column. Default = NULL for no filtering.
#' @param strFlagValue value of strFlagCol to keep. Default = NULL for no filtering.
#'
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count (number of Lab records), Exposure (Time on Treatment in Days), Rate (AE/Day)
#'
#' @examples
#' 
#'  dfRDSL <- clindata::rawplus_rdsl %>% dplyr::filter(!is.na(TimeOnTreatment))
#'  dfInput <- LabAbnorm_Map_Raw( clindata::rawplus_covlab, dfRDSL)
#'  
#'  dfInput <- LabAbnorm_Map_Raw(dfLab = clindata::rawplus_covlab, dfRDSL = dfRDSL, strTypeCol = 'LBTEST',strTypeValue =  "ALT (SGPT)", strFlagCol = 'TOXFLG', strFlagValue = 1 )
#'
#' @import dplyr
#'
#' @export

LabAbnorm_Map_Raw <- function( dfLab, dfRDSL, strExposureCol='TimeOnTreatment',strTypeCol = NULL,strTypeValue =  NULL, strFlagCol = NULL, strFlagValue = NULL   ){
  
    
      
  
    stopifnot(
        "dfLab dataset not found"=is.data.frame(dfLab),
        "RDSL dataset is not found"=is.data.frame(dfRDSL),
        "SUBJID column not found in dfLab"="SUBJID" %in% names(dfLab),
        "strExposureCol is not character"=is.character(strExposureCol),
        "SubjectID, SiteID and strExposureCol columns not found in dfRDSL"=all(c("SubjectID","SiteID",strExposureCol) %in% names(dfRDSL)),
        "NAs found in SUBJID column of dfLab" = all(!is.na(dfLab$SUBJID)),
        "NAs found in Subject ID column of dfRDSL" = all(!is.na(dfRDSL$SubjectID))
    )
    
  dfLab <- util_filter_df(dfLab,strTypeCol,strTypeValue )
  
  dfLab <- util_filter_df(dfLab,strFlagCol,strFlagValue )

    dfInput <-  dfRDSL %>%
        rowwise() %>%
        mutate(Count =sum(dfLab$SUBJID==.data$SubjectID, na.rm = TRUE)) %>%
        rename(Exposure = all_of(strExposureCol)) %>%
        mutate(Rate = .data$Count/.data$Exposure) %>%
        select(.data$SubjectID,.data$SiteID, .data$Count, .data$Exposure, .data$Rate) %>%
        ungroup()

    return(dfInput)
}



