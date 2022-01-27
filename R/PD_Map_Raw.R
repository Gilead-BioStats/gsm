#' Protocol Deviation Assessment Mapping from Raw Data- Make Input Data
#' 
#' Convert from raw data format to needed input format for Safety Assessment
#' Requires the following raw datasets: subid, ex, pd
#'
#' @param dfPd  PD dataset with columns SUBJID and rows for each Protocol Deviation 
#' @param  dfVisit data frame of visit information with required columns SUBJID INVID FOLDERNAME RECORDDATE
#' @param  dfStud optional, if no data frame is supplied will assume no subject completed study, otherwise
#' requires data frame of study completion information with columns SUBJID COMPYN_STD COMPREAS
#' @param  dtSnapshot date of data snapshot, if NULL, will impute to be current date
#' 
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count, Rate, Unit
#' 
#' @import dplyr
#' 
#' @export

PD_Map_Raw <- function( 
  dfPd = NULL,
  dfVisit = NULL,
  dfStud = NULL,
  dtSnapshot = NULL 
){    
    ### Requires raw datasets: subid, ex, ae
    if( is.null(dfPd) )  stop("dfPd dataset not found")
    if( is.null(dfVisit) )  stop("dfVisit dataset not found")
    if( is.null(dfStud) )  stop("dfStud dataset not found")
    
    ### Check required columns
    if( ! all(c("SUBJID") %in% names(dfPd)) ) stop( "SUBJID columns are required in PD dataset" )
            

    dfInput02 <- TimeOnStudy(dfVisit, dfStud, dtSnapshot) 

    # get PD count
    pdCounts <- dfPd %>% 
        mutate(SubjectID = as.character(.data$SUBJID)) %>%
        group_by(.data$SubjectID)%>%
        summarise(Count=n())%>%
        select(.data$SubjectID, .data$Count)

    dfInput <- dfInput02 %>%
        left_join(pdCounts) %>%
        mutate(Count = ifelse(is.na(.data$Count),0,.data$Count))%>%
        mutate(Unit="Days")%>%
        mutate(Rate = .data$Count / as.numeric(.data$TimeOnStudy) ) %>%
        select( .data$SubjectID,   .data$SiteID,  .data$Count ,  .data$TimeOnStudy ,  .data$Rate ,  .data$Unit)

    return(dfInput)    
}