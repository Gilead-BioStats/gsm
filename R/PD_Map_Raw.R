#' Protocol Deviation Assessment Mapping from Raw Data- Make Input Data
#'
#' Convert from raw data format to needed input format for Safety Assessment
#' Requires the following raw datasets: subid, ex, pd
#'
#' @details
#' 
#' This function combines raw AE data with exposure data calculated by clindata::TreatmentExposure to create the required input for \code{\link{AE_Assess}}. 
#' 
#' @section Data Specification:
#' 
#' This function creates an input dataset for the Adverse Event Assessment (\code{\link{AE_Assess}}) by adding Adverse Event Counts to basic subject-level treatment exposure data from \code{\link{TreatmentExposure}}. 
#' 
#' The following columns are required:
#' - `dfPD`
#'     - `SUBJID` - Unique subject ID
#' - `dfTOS`
#'     - `SubjectID` - Unique subject ID
#'     - `SiteID` - Site ID
#'     - `Exposure` - Treatment Exposure in days.
#' 
#' 
#'
#' @param dfPD  PD dataset with SUBJID column and rows for each Protocol Deviation 
#' @param dfTOS Time on Study data.set in format produced by clindata::TimeOnStudy 
#' 
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count, Exposure, Rate
#' 
#' 
#' @examples
#'  dfTos <- clindata::TimeOnStudy(dfVisit = clindata::raw_visdt,dfStud = clindata::raw_studcomp) 
#'  dfInput <- PD_Map_Raw(dfPD = clindata::raw_protdev,dfTOS = dfTos)
#' 
#' @import dplyr
#'
#' @export

PD_Map_Raw <- function( dfPD = NULL, dfTOS = NULL ){
    stopifnot(
        "PD dataset not found"=is.data.frame(dfPD),
        "Time on Study dataset is not found"=is.data.frame(dfTOS),
        "SUBJID column not found in dfPD"="SUBJID" %in% names(dfPD),
        "SubjectID, SiteID and Exposure columns not found in dfTOS"=all(c("SubjectID","SiteID","Exposure") %in% names(dfTOS))
    )

    dfInput <-  dfTOS %>%
        rowwise() %>%
        mutate(Count = sum(dfPD$SUBJID==.data$SubjectID, na.rm = TRUE)) %>% 
        mutate(Rate = .data$Count/.data$Exposure) %>%
        select(.data$SubjectID, .data$SiteID, .data$Count, .data$Exposure, .data$Rate) %>%
        ungroup()

    return(dfInput)
}
