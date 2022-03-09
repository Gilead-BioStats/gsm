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
#'     - Value specified in strCategoryCol  - IE Category; "IECAT" by default
#'     - Value specified in strResultCol  - Incl criteria not met Excl criteria met; "IEORRES_STD" by default
#' - `dfRDSL`
#'     - `SubjectID` - Unique subject ID
#'     - `SiteID` - Site ID
#'
#' @param dfIE ie dataset with columns SUBJID and values specified in strCategoryCol and strResultCol.
#' @param dfRDSL Subject-level Raw Data (RDSL) required columns: SubjectID SiteID
#' @param strCategoryCol Name ofcCriteria category column. default = 'IECAT'
#' @param vCategoryValues Category values (of column in dfIE specified by strCategoryCol) Default =  c("Exclusion","Inclusion").
#' @param strResultCol Name of criteria Result column. Default = "IEORRES_STD".
#' @param vExpectedResultValues Vector containing expected values for the inclusion/exclusion criteria stored in dfIE$IEORRES. Defaults to c(0,1) where 0 is expected when dfIE$IECAT == "Exclusion" and 1 is expected when dfIE$IECAT=="Inclusion".
#'
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count
#'
#' @examples
#'
#' dfInput <- IE_Map_Raw(
#'    clindata::raw_ie_all , 
#'    clindata::rawplus_rdsl,
#'    strCategoryCol = 'IECAT_STD', 
#'    vCategoryValues= c("EXCL","INCL"),
#'    strResultCol = 'IEORRES',
#'    vExpectedResultValues=c(0,1)
#')
#'
#' @import dplyr
#'
#' @export
IE_Map_Raw <- function(
  dfIE,
  dfRDSL,
  strCategoryCol = 'IECAT',
  vCategoryValues =  c("Exclusion","Inclusion"),
  strResultCol = 'IEORRES_STD',
  vExpectedResultValues = c(0,1)
){

  ### Requires raw ie dataset
  if( ! all(c("SUBJID", strCategoryCol, strResultCol) %in% names(dfIE)) ) stop(paste0("SUBJID, ",strCategoryCol,", and " , strResultCol, " columns are required in ie dataset") )
  if( !(all(c("SubjectID","SiteID") %in% names(dfRDSL)))) stop("SubjectID and SiteID column are required in RDSL dataset" )

  stopifnot(
    "length of vExpectedResultValues is not equal to 2"= (length( vExpectedResultValues) ==2),
    "length of vCategoryValues is not equal to 2"= (length(  vCategoryValues) ==2),
    "IE dataset not found" = !is.null(dfIE),
    "dfRDSL dataset not found" = !is.null(dfRDSL),
    "dfIE$SUBJID contains NA value(s)" = all(!is.na(dfIE[["SUBJID"]])),
    "strCategoryCol contains NA value(s)" = all(!is.na(dfIE[[strCategoryCol]])),
    "strResultCol contains NA value(s)" = all(!is.na(dfIE[[strResultCol]]))
    )

  # filter records where SUBJID is missing and create basic flags
  dfIE_long <- dfIE %>%
    filter(.data$SUBJID !="")%>%
    select(.data$SUBJID, .data[[strCategoryCol]],  .data[[strResultCol]]) %>%
    mutate(expected=ifelse(.data[[strCategoryCol]] ==vCategoryValues[1],vExpectedResultValues[1],vExpectedResultValues[2])) %>%
    mutate(valid=.data[[strResultCol]]==.data$expected)%>%
    mutate(invalid=.data[[strResultCol]]!=.data$expected)%>%
    mutate(missing=!(.data[[strResultCol]] %in% vExpectedResultValues))

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
    ungroup()

  missIE <- anti_join( dfIE_Subj, dfRDSL, by="SubjectID")
  if( nrow(missIE) > 0 ) warning("Not all SubjectID in IE found in RDSL")

  # merge IE and RDSL
  dfInput <- dfRDSL %>%
    select(.data$SubjectID, .data$SiteID)%>%
    inner_join(dfIE_Subj, by="SubjectID") %>%
    select(.data$SubjectID, .data$SiteID, .data$Total, .data$Valid, .data$Invalid, .data$Missing, .data$Count)

  #Throw warning if a an ID in IE isn't found in RDSL

  return(dfInput)
}
