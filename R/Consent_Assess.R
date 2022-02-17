#' Consent Assessment 
#' 
#' @details
#'  
#' The Consent Assessment uses the standard GSM data pipeline (TODO add link to data vignette) to flag sites with participants who started study activities before consent was finalized. More details regarding the data pipeline and statistical methods are described below. 
#' 
#' @section Data Specification:
#' 
#' The input data (`dfInput`) for Consent Assessment is typically created using \code{\link{Consent_Map_Raw}} and should be one record per person with columns for: 
#' - `SubjectID` - Unique subject ID
#' - `SiteID` - Site ID
#' - `Count` - Number of findings of errors/outliers. 
#' 
#' The Assessment 
#' - \code{\link{Transform_EventCount}} creates `dfTransformed`.
#' - \code{\link{Analyze_MissingInvalid}} creates `dfAnalyzed`.
#' - \code{\link{Flag}} creates `dfFlagged`.
#' - \code{\link{Summarize}} creates `dfSummary`.
#' 
#' 
#'  
#' @param dfInput input data with one record per person and the following required columns: SubjectID, SiteID, Count.
#' @param nThreshold integer threshold values Flagging, integer values greater than will be flagged.
#' @param cLabel Assessment label 
#' @param bDataList Should all assessment datasets be returned as a list? If False (the default), only the summary/finding data frame is returned
#'
#'
#' @examples 
#' 
#' dfConsent <- tibble::tribble(~SUBJID,  ~INVID,  ~CONSCAT_STD , ~CONSYN , ~CONSDAT,
#'                             1,       1,  "MAINCONSENT",    "Yes", "2014-12-25",
#'                             2,       2,  "MAINCONSENT",    "Yes", "2014-12-25",
#'                             3,       2,  "MAINCONSENT",     "No", "2014-12-25",
#'                             4,       2,   "NonCONSENT",    "Yes", "2014-12-25",
#'                             5,       3,  "MAINCONSENT",    "Yes", "2014-12-25"  )
#'
#' dfIxrsrand <- tibble::tribble(~SUBJID, ~RGMNDTN,
#'                              1,   "2013-12-25",
#'                              2,   "2015-12-25",
#'                              3,   "2013-12-25",
#'                              4,   "2013-12-25",
#'                              5,   "2013-12-25")
#'
#'
#' dfInput <-  Consent_Map_Raw(dfConsent = dfConsent, dfIxrsrand = dfIxrsrand)
#' lAssess <- Consent_Assess( dfInput , bDataList = TRUE)
#' 
#'  
#'
#' @return If `bDataList` is false (the default), the summary data frame (`dfSummary`) is returned. If `bDataList` is true, a list containing all data in the standard data pipeline (`dfInput`, `dfTransformed`, `dfAnalyzed`, `dfFlagged` and `dfSummary`) is returned. 
#' 
#' @export

Consent_Assess <- function( dfInput, nThreshold=0.5,  cLabel="", bDataList=FALSE){
  
  stopifnot(
    "dfInput is not a data.frame" = is.data.frame(dfInput),
    "cLabel is not character" = is.character(cLabel),
    "bDataList is not logical" = is.logical(bDataList),
    "One or more of these columns: SubjectID, SiteID, Count, Exposure, and Rate not found in dfInput"=all(c("SubjectID","SiteID", "Count") %in% names(dfInput))
  )
  
  lAssess <- list()
  lAssess$dfInput <- dfInput
  lAssess$dfTransformed <- gsm::Transform_EventCount( lAssess$dfInput, cCountCol = 'Count'  )
  lAssess$dfAnalyzed <-lAssess$dfTransformed %>% mutate(PValue = NA)
  lAssess$dfFlagged <- gsm::Flag( lAssess$dfAnalyzed ,vThreshold = c(NA,nThreshold), strColumn = "TotalCount" )
  lAssess$dfSummary <- gsm::Summarize( lAssess$dfFlagged, cAssessment="Main Consent", cLabel= cLabel)
  
  if(bDataList){
    return(lAssess)
  } else {
    return(lAssess$dfSummary)
  }
}

