#' Protocol Deviation Assessment Mapping from Raw Data- Make Input Data
#'
#' Convert from raw data format to needed input format for Safety Assessment
#'
#' @details
#' 
#' This function combines raw PD data with exposure data calculated by clindata::TimeOnStudy to create the required input for \code{\link{AE_Assess}}. 
#' 
#' @section Data Specification:
#' 
#' This function creates an input dataset for the Protocol Deviation (\code{\link{PD_Assess}}) by adding Protocol Deviation Counts to basic subject-level time on study data from `clindata::TimeOnStudy`. 
#' 
#' The following columns are required:
#' - `dfPD`
#'     - `SUBJID` - Unique subject ID
#' - `dfRDSL`
#'     - `SubjectID` - Unique subject ID
#'     - `SiteID` - Site ID
#'     - Value specified in strExposureCol - Time on Study in days; "TimeOnStudy" by default
#' 
#' 
#'
#' @param dfPD  PD dataset with SUBJID column and rows for each Protocol Deviation 
#' @param dfRDSL Subject-level Raw Data (RDSL) required columns: SubjectID, SiteID, value specified in strExposureCol
#' @param strExposureColumn Name of exposure column. 'TimeOnStudy' by default
#' 
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count, Exposure, Rate
#' 
#' 
#' @examples
#'  dfInput <- PD_Map_Raw(clindata::raw_protdev,clindata::rawplus_rdsl)
#' 
#' @import dplyr
#'
#' @export

PD_Map_Raw <- function( dfPD = NULL, dfRDSL = NULL, strExposureCol="TimeOnStudy" ){
    stopifnot(
        "PD dataset not found"=is.data.frame(dfPD),
        "Time on Study dataset is not found"=is.data.frame(dfRDSL),
        "SUBJID column not found in dfPD"="SUBJID" %in% names(dfPD),
        "strExposureCol is not character"=is.character(strExposureCol),
        "SubjectID, SiteID and strExposureCol columns not found in dfRDSL"=all(c("SubjectID","SiteID",strExposureCol) %in% names(dfRDSL))
    )

    dfInput <-  dfRDSL %>%
        rowwise() %>%
        mutate(Count = sum(dfPD$SUBJID==.data$SubjectID, na.rm = TRUE)) %>% 
        rename(Exposure = strExposureCol) %>%
        mutate(Rate = .data$Count/.data$Exposure) %>%
        select(.data$SubjectID, .data$SiteID, .data$Count, .data$Exposure, .data$Rate) %>%
        ungroup()

    return(dfInput)
}
