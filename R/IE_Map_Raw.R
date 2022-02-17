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
#'     - `IECAT` - IE Category
#'     - `IETEST` - Criterion Description (truncated)
#'     - `IEORRES` - Incl criteria not met Excl criteria met.
#' - `dfRDSL`
#'     - `SubjectID` - Unique subject ID
#'     - `SiteID` - Site ID
#' 
#' @param dfIe ie dataset with columns SUBJID IVID IECAT IETESTCD IEORRES
#' @param dfRDSL Subject-level Raw Data (RDSL) required columns: SubjectID SiteID
#' @param vExpected Vector containing expected values for the inclusion/exclusion criteria stored in dfIE$IEORRES. Defaults to c(0,1) where 0 is expected when dfIE$IECAT == "Exclusion" and 1 is expected when dfIECAT=="Inclusion".
#' 
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count
#' 
#' @examples
#'
#' dfInput <- IE_Map_Raw(clindata::raw_ie_a2, clindata::rawplus_rdsl)
#' 
#' @import dplyr
#' 
#' @export 
IE_Map_Raw <- function( 
  dfIe = NULL,
  dfRDSL = NULL,
  vExpected = c(0,1)
){

  ### Requires raw ie dataset
  if(is.null(dfIe)) stop("IE dataset not found")
  if( ! all(c("SUBJID", "IECAT", "IETESTCD","IETEST", "IEORRES") %in% names(dfIe)) ) stop("SUBJID, IECAT, IETEST, IETESTCD, IEORRES columns are required in ie dataset" )
  if(is.null(dfRDSL)) stop("RDSL dataset not found")
  if( !(all(c("SubjectID","SiteID") %in% names(dfRDSL)))) stop("SubjectID and SiteID column are required in RDSL dataset" )
  
  # filter records where SUBJID is missing and create basic flags
  dfIE_long <- dfIe %>% 
    filter(.data$SUBJID !="")%>%
    select(.data$SUBJID, .data$IECAT, .data$IETESTCD, .data$IETEST, .data$IEORRES) %>%
    mutate(expected=ifelse(.data$IECAT=="Exclusion",vExpected[1],vExpected[2])) %>%
    mutate(valid=.data$IEORRES==.data$expected)%>%
    mutate(invalid=.data$IEORRES!=.data$expected)%>%
    mutate(missing=!(.data$IEORRES %in% vExpected))
  
  # collapse long data to one record per participant
  dfIE_Subj <- dfIE_long %>%
    group_by(.data$SUBJID) %>%
    summarise(
      Total=n(), 
      Valid=sum(.data$valid), 
      Invalid=sum(.data$invalid), 
      Missing=sum(.data$missing)
    )%>%
    mutate(Count = .data$Invalid + .data$Missing) %>%
    rename(SubjectID =  .data$SUBJID) %>%
    select(.data$SubjectID, .data$Count) %>%
    ungroup()
  
  # merge IE and RDSL
  dfInput <- dfRDSL %>% 
    select(.data$SubjectID, .data$SiteID)%>%
    left_join(dfIE_Subj, by="SubjectID") %>%
    select(.data$SubjectID, .data$SiteID, .data$Count)
  
  #Throw warning if a an ID in IE isn't found in RDSL
  missIE <- anti_join( dfIE_Subj, dfRDSL, by="SubjectID")
  if( nrow(missIE) > 0 ) warning("Not all SubjectID in IE found in RDSL")

  return(dfInput)
}