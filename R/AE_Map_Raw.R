#' AE Assessment - Raw Mapping 
#' 
#' Convert Raw data, typically processed case report form data - to input format for Safety Assessment.
#' 
#' @details
#' 
#' This function combines raw AE data with exposure data calculated by \code{\link{TreatmentExposure}} to create the required input for \code{\link{AE_Assess}}. 
#' 
#' @section Data Specification:
#' 
#' This function creates an input dataset for the Adverse Event Assessment (\code{\link{AE_Assess}}) by adding Adverse Event Counts to basic subject-level treatment exposure data from \code{\link{TreatmentExposure}}. 
#' 
#' The following columns are required:
#' - `dfAE`
#'     - `SUBJID` - Unique subject ID
#' - `dfExposure`
#'     - `SubjectID` - Unique subject ID
#'     - `SiteID` - Site ID
#'     - `Exposure` - Treatment Exposure in days.
#' 
#' Note that the function can generate data summaries for specific types of AEs, but passing filtered ADAE data to dfADAE. 
#'
#' @param dfAE AE dataset with columns SUBJID and rows for each AE record
#' @param dfExposure exposure dataset calculated via \code{\link{TreatmentExposure}} required columns: SubjectID, SiteID, Exposure
#' 
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count (number of AEs), Exposure (Time on Treatment in Days), Rate (AE/Day)
#' 
#' @examples
#'  dfExposure <- TreatmentExposure(  dfEx = clindata::raw_ex,  dfSdrg = NULL, dtSnapshot = NULL)
#'  dfInput <- AE_Map_Raw(clindata::raw_ae, dfExposure)
#' 
#' 
#' @import dplyr 
#' 
#' @export

AE_Map_Raw <- function( dfAE = NULL, dfExposure = NULL){
    stopifnot(
        "ae dataset not found"=is.data.frame(dfAE),
        "exposure dataset is not found"=is.data.frame(dfExposure),
        "SUBJID column not found in dfAE"="SUBJID" %in% names(dfAE),
        "SubjectID, SiteID and Exposure columns not found in dfExposure"=all(c("SubjectID","SiteID","Exposure") %in% names(dfExposure))
    )
  


    dfInput <-  dfExposure %>% 
        rowwise() %>%
        mutate(Count =sum(dfAE$SUBJID==.data$SubjectID)) %>% 
        mutate(Rate = .data$Count/.data$Exposure) %>%
        select(.data$SubjectID,.data$SiteID, .data$Count, .data$Exposure, .data$Rate) %>%
        ungroup()
        
    return(dfInput)
}