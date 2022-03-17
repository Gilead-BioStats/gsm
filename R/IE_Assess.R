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
#' @section Statistical Assumptions:
#'
#' This Assessment finds any sites where one or more subjects which have Inclusion / Exclusion data that is either missing or has inconsistent data recorded for
#' inclusion / exclusion data. N' in the summary represents the number of subjects in a study that meet one or more criteria. Sites
#' With N greater than user specified `nThreshold` will be flagged.
#'
#'
#' @param dfInput input data with one record per person and the following required columns: SubjectID, SiteID, Count,
#' @param nThreshold Any sites where 'N' is greater than nThreshold will be flagged. Default value is 0.5, which flags any site with one or more subjects meeting any of the criteria.
#' @param strLabel Assessment label
#'
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
#' IE_Summary <- IE_Assess(dfInput)$dfSummary
#'
#'
#' @return A list containing all data and metadata in the standard data pipeline (`dfInput`, `dfTransformed`, `dfAnalyzed`, `dfFlagged`, `dfSummary`, `strFunctionName`, and `lParams`) is returned.
#'
#' @export

IE_Assess <- function(dfInput, nThreshold=0.5, strLabel=""){

  stopifnot(
    "dfInput is not a data.frame" = is.data.frame(dfInput),
    "strLabel is not character" = is.character(strLabel),
    "One or more of these columns: SubjectID, SiteID, Count, Exposure, and Rate not found in dfInput"=all(c("SubjectID","SiteID", "Count") %in% names(dfInput)),
    "nThreshold must be numeric" = is.numeric(nThreshold),
    "nThreshold must be length 1" = length(nThreshold) ==1
  )

  lAssess <- list()
  lAssess$strFunctionName <- deparse(sys.call()[1])
  lAssess$lParams <- lapply(as.list(match.call()[-1]), function(x) as.character(x))
  lAssess$dfInput <- dfInput
  lAssess$dfTransformed <- gsm::Transform_EventCount( lAssess$dfInput, strCountCol = "Count")
  lAssess$dfAnalyzed <-lAssess$dfTransformed %>% mutate(Estimate = .data$TotalCount)
  lAssess$dfFlagged <- gsm::Flag( lAssess$dfAnalyzed , vThreshold = c(NA,nThreshold), strColumn = "Estimate" )
  lAssess$dfSummary <- gsm::Summarize( lAssess$dfFlagged, strScoreCol="TotalCount", strAssessment="Inclusion/Exclusion", strLabel= strLabel)
  
  

  return(lAssess)

}

