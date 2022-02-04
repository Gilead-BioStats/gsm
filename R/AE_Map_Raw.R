#' Safety Assessment Mapping from Raw Data to Input Data
#' 

#' @details
#' 
#' Convert from raw data format to needed input format for Safety Assessment
#' Requires the following raw datasets: ae. Also requires Exposure data calculated by \code{\link{TreatmentExposure}}.
#'  
#' This function maps the data to the required input for  \code{\link{AE_Assess}}. 
#' 
#' @section Data Pipeline:
#' 
#' The input data in (`ae`) Must have these required columns
#' - `SUBJID` - Unique subject ID

#'
#' The input data in (`dfExposure`) is calculated by:  \code{\link{TreatmentExposure}} and must have these required columns:
#' - `SubjectID` - Unique subject ID
#' - `SiteID` - Site ID
#' - `Exposure`  - Exposure
#' 
#'
#' @param dfAE AE dataset with columns SUBJID and rows for each AE record
#' @param dfExposure exposure dataset calculated via \code{\link{TreatmentExposure}} required columns: SubjectID,SiteID,Exposure
#' 
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count, Exposure, Rate, Unit
#' 
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
        select(.data$SubjectID,.data$SiteID, .data$Count, .data$Exposure, .data$Rate)
        
    return(dfInput)
}