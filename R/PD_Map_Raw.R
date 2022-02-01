#' Protocol Deviation Assessment Mapping from Raw Data- Make Input Data
#' 
#' Convert from raw data format to needed input format for Safety Assessment
#' Requires the following raw datasets: subid, ex, pd
#'
#' @param dfTos data.frame Time on Study data in format produced by \code{\link{TimeOnStudy}} 
#' @param dfPd  PD dataset with columns SUBJID and rows for each Protocol Deviation 
#'
#' 
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count, Rate, Unit
#' 
#' @import dplyr
#' 
#' @export

PD_Map_Raw <- function( 
  dfTos = NULL,
  dfPd = NULL
){    
    ### Requires raw datasets: subid, ex, ae
    if( is.null(dfPd) )  stop("dfPd dataset not found")
    if( is.null(dfTOS) )  stop("dfTOS dataset not found")

    
    ### Check required columns
    if( ! all(c("SUBJID") %in% names(dfPd)) ) stop( "SUBJID columns are required in PD dataset" )
    if( ! all(c("SubjectID" ,"SiteID", "firstDate","lastDate", "TimeOnStudy") %in% names(dfTOS)) ) stop( "SUBJID columns are required in PD dataset" )
            

    # get PD count
    pdCounts <- dfPd %>% 
        mutate(SubjectID = as.character(.data$SUBJID)) %>%
        group_by(.data$SubjectID)%>%
        summarise(Count=n())%>%
        select(.data$SubjectID, .data$Count)

    dfInput <- dfTOS %>%
        left_join(pdCounts) %>%
        mutate(Count = ifelse(is.na(.data$Count),0,.data$Count))%>%
        mutate(TimeOnStudy = as.numeric(.data$TimeOnStudy)) %>%
        mutate(Unit="Days")%>%
        mutate(Rate = .data$Count / .data$TimeOnStudy ) %>%
        select( .data$SubjectID,   .data$SiteID,  .data$Count ,  .data$TimeOnStudy ,  .data$Rate ,  .data$Unit)

    return(dfInput)    
}