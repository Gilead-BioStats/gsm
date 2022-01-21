#' Inclusion/Exclusion Assessment Mapping from Raw Data- Make Input Data
#' 
#' Convert from raw data format to needed input format for Inclusion/Exclusion Assessment
#'
#' @param dfIe ie dataset with columns SUBJID IECAT IETEST IEORRES
#' 
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Total, Valid, Invalid, Missing, Details
#' 
#' @import dplyr
#' 
#' @export 
IE_Map_Raw <- function( 
  dfIe = NULL
){

  ### Requires raw ie dataset
  if(is.null(dfIe)) stop("IE dataset not found")
  if( ! all(c("SUBJID", "INVID", "IECAT", "IETESTCD","IETEST", "IEORRES") %in% names(dfIe)) ) stop("SUBJID, IECAT, IETEST, IETESTCD, IEORRES columns are required in ie dataset" )
  
  # filter records where SUBJID is missing and create basic flags
  dfInput_long <- dfIe %>% 
    filter(SUBJID !="")%>%
    select(SUBJID, INVID, IECAT, IETESTCD,IETEST,IEORRES) %>%
    mutate(expected=ifelse(IECAT=="Exclusion","No","Yes")) %>%
    mutate(valid=IEORRES==expected)%>%
    mutate(invalid=IEORRES!=expected)%>%
    mutate(missing=!(IEORRES %in% c("Yes","No")))
  
  # collapse long data to one record per participant
  dfInput <- dfInput_long %>%
    group_by(SUBJID) %>%
    summarise(
      SiteID=first(INVID),
      Total=n(), 
      Valid=sum(valid), 
      Invalid=sum(invalid), 
      Missing=sum(missing)
    )

  return(dfInput)
}