#' Inclusion/Exclusion Assessment Mapping from Raw Data- Make Input Data
#' 
#' Convert from raw data format to needed input format for Inclusion/Exclusion Assessment
#' 
#' @details
#' 
#' This function creates the required input for \code{\link{IE_Assess}}. 
#' 
#' @section Data Specification:
#' 
#' 
#' The following columns are required:
#' - `dfIE`
#'     - `SUBJID` - Unique subject ID
#'     - `INVID` - Investigator identifier
#'     - `IECAT` - IE Category
#'     - `IETEST` - Criterion Description (truncated)
#'     - `IEORRES` - Incl criteria not met Excl criteria met.
#' 
#'
#' @param dfIe ie dataset with columns SUBJID INVID IECAT IETESTCD IEORRES
#' @param vExpected default = c(0,1), expected values for IEORRES. 
#' 
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count
#' 
#' @examples
#'
#' dfInput <- IE_Map_Raw(clindata::raw_ie_a2)
#' 
#' @import dplyr
#' 
#' @export 
IE_Map_Raw <- function( 
  dfIe = NULL,
  vExpected = c(0,1)
){

  ### Requires raw ie dataset
  if(is.null(dfIe)) stop("IE dataset not found")
  if( ! all(c("SUBJID", "INVID", "IECAT", "IETESTCD","IETEST", "IEORRES") %in% names(dfIe)) ) stop("SUBJID, IECAT, IETEST, IETESTCD, IEORRES columns are required in ie dataset" )
  
  # filter records where SUBJID is missing and create basic flags
  dfInput_long <- dfIe %>% 
    filter(.data$SUBJID !="")%>%
    select(.data$SUBJID, .data$INVID, .data$IECAT, .data$IETESTCD, .data$IETEST, .data$IEORRES) %>%
    mutate(expected=ifelse(.data$IECAT=="Exclusion",vExpected[1],vExpected[2])) %>%
    mutate(valid=.data$IEORRES==.data$expected)%>%
    mutate(invalid=.data$IEORRES!=.data$expected)%>%
    mutate(missing=!(.data$IEORRES %in% vExpected))
  
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
    mutate(Count = .data$Invalid + .data$Missing) %>%
    rename(SubjectID =  .data$SUBJID) %>%
    select(.data$SubjectID, .data$SiteID, .data$Count) %>%
    ungroup()
  
  return(dfInput)
}