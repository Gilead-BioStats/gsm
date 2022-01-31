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
    filter(.data$SUBJID !="")%>%
    select(.data$SUBJID, .data$INVID, .data$IECAT, .data$IETESTCD, .data$IETEST, .data$IEORRES) %>%
    mutate(expected=ifelse(.data$IECAT=="Exclusion","No","Yes")) %>%
    mutate(valid=.data$IEORRES==.data$expected)%>%
    mutate(invalid=.data$IEORRES!=.data$expected)%>%
    mutate(missing=!(.data$IEORRES %in% c("Yes","No")))
  
  # collapse long data to one record per participant
  dfInput <- dfInput_long %>%
    group_by(.data$SUBJID) %>%
    summarise(
      SiteID=first(.data$INVID),
      Total=n(), 
      Valid=sum(.data$valid), 
      Invalid=sum(.data$invalid), 
      Missing=sum(.data$missing)
    )%>%
    mutate(InvalidMissing = .data$Invalid + .data$Missing)

  return(dfInput)
}