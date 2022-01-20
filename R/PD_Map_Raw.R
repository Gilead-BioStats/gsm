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
    dfSubid = NULL ,
    dfEx = NULL,
    dfPd = NULL
){    
    ### Requires raw datasets: subid, ex, ae
    if( is.null(dfSubid) ) stop("subid dataset not found")
    if( is.null(dfEx) )  stop("ex dataset not found")
    if( is.null(dfPd) )  stop("ae dataset not found")
    
    ### Check required columns
    if( ! all(c("SUBJID","INVID") %in% names(dfSubid)) ) stop( "SUBJID and INVID columns are required in subid dataset" )
    if( ! all(c("SUBJID","EXSTDAT","EXENDAT") %in% names(dfEx)) ) stop( "SUBJID, EXSTDAT, and EXENDAT columns are required in ex dataset" )
    if( ! all(c("SUBJID") %in% names(dfPd)) ) stop( "SUBJID columns are required in PD dataset" )
            
    # Pull SUBJID and INVID from dfSubid
    dfInput01 <- dfSubid %>% 
        filter(dfSubid$SUBJID != "") %>%
        mutate(SubjectID = as.character(SUBJID)) %>%
        mutate(SiteID = as.character(INVID)) %>%
        select(SubjectID, SiteID)
    
    # Calculate exposure from dfEx
    exposure<- dfEx %>% 
        mutate(SubjectID = as.character(SUBJID)) %>%    
        select(SubjectID, EXSTDAT, EXENDAT)

    dfInput02 <- dfInput01 %>%
        left_join(exposure) %>% 
        mutate(firstDose = lubridate::ymd(EXSTDAT)) %>%
        mutate(lastDose = lubridate::ymd(EXENDAT)) %>%
        mutate(Exposure = time_length(lastDose-firstDose, unit="days")+1)

    # get PD count
    pdCounts <- dfPd %>% 
        mutate(SubjectID = as.character(SUBJID)) %>%
        group_by(SubjectID)%>%
        summarise(Count=n())%>%
        select(SubjectID, Count)

    dfInput <- dfInput02 %>%
        left_join(pdCounts) %>%
        mutate(Count = ifelse(is.na(Count),0,Count))%>%
        mutate(Exposure = ifelse(is.na(Exposure),1,Exposure))%>%
        mutate(Unit="Days")%>%
        mutate(Rate = Count / Exposure) 

    return(dfInput)    
}