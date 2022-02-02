#' Protocol Deviation Assessment Mapping from Raw Data- Make Input Data
#' 
#' Convert from raw data format to needed input format for Safety Assessment
#' Requires the following raw datasets: subid, ex, pd
#'
#' @param dfPD  PD dataset with SUBJID column and rows for each Protocol Deviation 
#' @param dfTOS Time on Study data.set in format produced by \code{\link{TimeOnStudy}} 
#' 
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count, Exposure, Rate
#' 
#' @import dplyr
#' 
#' @export

PD_Map_Raw <- function( dfPD = NULL, dfTOS = NULL ){
    stopifnot(
        "PD dataset not found"=is.data.frame(dfPD),
        "Time on Study dataset is not found"=is.data.frame(dfTOS),
        "USUBJID column not found in dfPD"="SUBJID" %in% names(dfPD),
        "SubjectID, SiteID and TimeOnStudy columns not found in dfTOS"=all(c("SubjectID","SiteID","TimeOnStudy") %in% names(dfTOS))
    )

    dfInput <-  dfTOS %>% 
        rowwise() %>%
        mutate(Count = sum(dfPD$SUBJID==.data$SubjectID)) %>% 
        mutate(Rate = .data$Count/.data$TimeOnStudy) %>%
        select(.data$SubjectID, .data$SiteID, .data$Count, .data$TimeOnStudy, .data$Rate)

    return(dfInput)
}