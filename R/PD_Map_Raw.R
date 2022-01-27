#' Protocol Deviation Assessment Mapping from Raw Data- Make Input Data
#' 
#' Convert from raw data format to needed input format for Safety Assessment
#' Requires the following raw datasets: subid, ex, pd
#'
#' @param dfSubid  subid dataset with columns SUBJID INVID
#' @param dfEx  ex dataset with columns SUBJID EXSTDAT EXENDAT
#' @param dfPd  PD dataset with columns SUBJID and rows for each Protocol Deviation 

#' 
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count, Exposure, Rate, Unit
#' 
#' @import dplyr
#' @import lubridate
#' 
#' @export

PD_Map_Raw <- function( 
  dfPd = NULL,
  dfVisit = NULL,
  dfStud = NULL,
  dtSnapshot = NULL 
){    
    ### Requires raw datasets: subid, ex, ae
    if( is.null(dfSubid) ) stop("subid dataset not found")
    if( is.null(dfEx) )  stop("ex dataset not found")
    if( is.null(dfPd) )  stop("ae dataset not found")
    
    ### Check required columns
    if( ! all(c("SUBJID") %in% names(dfPd)) ) stop( "SUBJID columns are required in PD dataset" )
            

    dfInput02 <- TimeOnStudy(dfVisit, dfStud, dtSnapshot) %>% 
      rename(EXSTDAT = .data$firstDate, EXENDAT = .data$lastDate)  %>% 
      mutate(firstDose = lubridate::ymd(.data$EXSTDAT)) %>%
      mutate(lastDose = lubridate::ymd(.data$EXENDAT)) %>%
      mutate(Exposure = time_length(.data$lastDose-.data$firstDose, unit="days")+1)

    # get PD count
    pdCounts <- dfPd %>% 
        mutate(SubjectID = as.character(.data$SUBJID)) %>%
        group_by(.data$SubjectID)%>%
        summarise(Count=n())%>%
        select(.data$SubjectID, .data$Count)

    dfInput <- dfInput02 %>%
        left_join(pdCounts) %>%
        mutate(Count = ifelse(is.na(.data$Count),0,.data$Count))%>%
        mutate(Exposure = ifelse(is.na(.data$Exposure),1,.data$Exposure))%>%
        mutate(Unit="Days")%>%
        mutate(Rate = .data$Count / .data$Exposure) 
    # count / time on study.
    # subject / site / count / time on study / rate / unit
    
    # don't drop unit, add issue to potentially drop Unit col.

    return(dfInput)    
}