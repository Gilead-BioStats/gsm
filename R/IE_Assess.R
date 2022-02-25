#' Inclusion/Exclusion Assessment 

#' 
#' @details
#'  
#' The Inclusion/Exclusion Assessment uses the standard GSM data pipeline (TODO add link to data vignette) to flag sites with Inclusion / Exclusion irregularities. More details regarding the data pipeline and statistical methods are described below. 
#' 
#' @section Data Specification:
#' 
#' The input data (`dfInput`) for IE Assessment is typically created using \code{\link{IE_Map_Raw}} and should be one record per person with columns for: 
#' - `SubjectID` - Unique subject ID
#' - `SiteID` - Site ID
#' - `Count` - Number of findings of errors/outliers. 
#' 
#' The Assessment 
#' - \code{\link{Transform_EventCount}} creates `dfTransformed`.
#' - \code{\link{Flag}} creates `dfFlagged`.
#' - \code{\link{Summarize}} creates `dfSummary`.
#' 
#'  
#' @param dfInput input data with one record per person and the following required columns: SubjectID, SiteID, Count, 
#' @param nThreshold integer threshold values Flagging, integer values greater than will be flagged.
#' @param cLabel Assessment label 
#' @param bDataList Should all assessment datasets be returned as a list? If False (the default), only the summary/finding data frame is returned
#'
#'
#' @examples 
#' 
#'  dfInput <- tibble::tribble(        ~SubjectID, ~SiteID, ~Count,
#'                                           "0142", "X194X",     9,
#'                                           "0308", "X159X",     9,
#'                                           "0776", "X194X",     8,
#'                                           "1032", "X033X",     9
#'                                           )
#'                                           
#'  ie_summary <- IE_Assess(dfInput)
#'  
#'  ie_input <- IE_Map_Raw(clindata::raw_ie_all , clindata::rawplus_rdsl_s, strCategoryCol = 'IECAT_STD', strResultCol = 'IEORRES')
#'  ie_input <-  ie_input %>% filter(!is.na(.data$Count))
#'  
#'  ie_summary2 <- IE_Assess(ie_input)
#'
#'
#' @return If `bDataList` is false (the default), the summary data frame (`dfSummary`) is returned. If `bDataList` is true, a list containing all data in the standard data pipeline (`dfInput`, `dfTransformed`, `dfAnalyzed`, `dfFlagged` and `dfSummary`) is returned. 
#' 
#' @export

IE_Assess <- function( dfInput, nThreshold=0.5,  cLabel="", bDataList=FALSE){
  
  stopifnot(
    "dfInput is not a data.frame" = is.data.frame(dfInput),
    "cLabel is not character" = is.character(cLabel),
    "bDataList is not logical" = is.logical(bDataList),
    "One or more of these columns: SubjectID, SiteID, Count, Exposure, and Rate not found in dfInput"=all(c("SubjectID","SiteID", "Count") %in% names(dfInput))
  )
  
  
  lAssess <- list()
  lAssess$dfInput <- dfInput
  lAssess$dfTransformed <- gsm::Transform_EventCount( lAssess$dfInput, cCountCol = "Count")
  lAssess$dfAnalyzed <-lAssess$dfTransformed %>% mutate(PValue = NA) %>% mutate(Estimate = .data$TotalCount)
  lAssess$dfFlagged <- gsm::Flag( lAssess$dfAnalyzed , vThreshold = c(NA,nThreshold), strColumn = "Estimate" )
  lAssess$dfSummary <- gsm::Summarize( lAssess$dfFlagged, cAssessment="Inclusion/Exclusion", cLabel= cLabel)
  
  if(bDataList){
    return(lAssess)
  } else {
    return(lAssess$dfSummary)
  }
}

