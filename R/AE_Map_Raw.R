#' AE Assessment - Raw Mapping
#'
#' Convert Raw data, typically processed case report form data - to input format for Safety Assessment.
#'
#' @details
#' 
#' This function combines AE data with treatment exposure from subject-level Raw Data (RDSL) to create the required input for \code{\link{AE_Assess}}. 
#' 
#' @section Data Specification:
#'
#' This function creates an input dataset for the Adverse Event Assessment (\code{\link{AE_Assess}}) by adding Adverse Event Counts to basic subject-level treatment exposure data from `clindata::TreatmentExposure`.
#'
#' The following columns are required:
#' - `dfAE`
#'     - `SUBJID` - Unique subject ID
#' - `dfRDSL`
#'     - `SubjectID` - Unique subject ID
#'     - `SiteID` - Site ID
#'     - Value specified in strExposureCol - Treatment Exposure in days; "TimeOnTreatment" by default
#'
#' Note that the function can generate data summaries for specific types of AEs, but passing filtered ADAE data to dfADAE.
#'
#' @param dfAE AE dataset with columns SUBJID and rows for each AE record
#' @param dfRDSL Subject-level Raw Data (RDSL) required columns: SubjectID, SiteID, value specified in strExposureCol
#' @param strExposureCol Name of exposure column. 'TimeOnTreatment' by default
#'
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count (number of AEs), Exposure (Time on Treatment in Days), Rate (AE/Day)
#' 
#' @examples
#'  dfInput <- AE_Map_Raw(clindata::raw_ae, clindata::rawplus_rdsl)
#' 
#' @import dplyr 
#' 
#' @export

AE_Map_Raw <- function( dfAE, dfRDSL, strExposureCol="TimeOnTreatment"){
    stopifnot(
        "ae dataset not found"=is.data.frame(dfAE),
        "RDSL dataset is not found"=is.data.frame(dfRDSL),
        "SUBJID column not found in dfAE"="SUBJID" %in% names(dfAE),
        "strExposureCol is not character"=is.character(strExposureCol),
        "SubjectID, SiteID and strExposureCol columns not found in dfRDSL"=all(c("SubjectID","SiteID",strExposureCol) %in% names(dfRDSL))
    )

    dfInput <-  dfRDSL %>%
        rowwise() %>%
        mutate(Count =sum(dfAE$SUBJID==.data$SubjectID, na.rm = TRUE)) %>% 
        rename(Exposure = strExposureCol) %>%
        mutate(Rate = .data$Count/.data$Exposure) %>%
        select(.data$SubjectID,.data$SiteID, .data$Count, .data$Exposure, .data$Rate) %>%
        ungroup()

    return(dfInput)
}
