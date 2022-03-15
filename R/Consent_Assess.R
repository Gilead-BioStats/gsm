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
#' - \code{\link{Flag}} creates `dfFlagged`.
#' - \code{\link{Summarize}} creates `dfSummary`.
#'
#' @section Statistical Assumptions:
#'
#' This Assessment finds any sites where one or more subjects meets any of the following citeria: No Consent, Missing Consent, Missing Randomization Date, or
#' Consent date later in time than the Randomization Date. 'N' in the summary represents the number of subjects in a study that meet one or more criteria. Sites
#' With N greater than user specified `nThreshold` will be flagged.
#'
#'
#'
#' @param dfInput input data with one record per person and the following required columns: SubjectID, SiteID, Count.
#' @param nThreshold Any sites where 'N' is greater than nThreshold will be flagged. Default value is 0.5, which flags any site with one or more subjects meeting any of the criteria.
#' @param strLabel Assessment label.
#' @param bDataList Should all assessment datasets be returned as a list? If False (the default), only the summary/finding data frame is returned.
#'
#'
#' @examples
#'
#'dfInput <- Consent_Map_Raw(
#' dfConsent = clindata::raw_consent,
#' dfRDSL = clindata::rawplus_rdsl,
#' strConsentReason = NULL
#')
#'
#'Consent_Assess(dfInput)
#'
#'
#'
#' @return If `bDataList` is false (the default), the summary data frame (`dfSummary`) is returned. If `bDataList` is true, a list containing all data in the standard data pipeline (`dfInput`, `dfTransformed`, `dfAnalyzed`, `dfFlagged` and `dfSummary`) is returned.
#'
#' @export

Consent_Assess <- function( dfInput, nThreshold=0.5,  strLabel="", bDataList=FALSE){

  stopifnot(
    "dfInput is not a data.frame" = is.data.frame(dfInput),
    "strLabel is not character" = is.character(strLabel),
    "bDataList is not logical" = is.logical(bDataList),
    "One or more of these columns: SubjectID, SiteID,and Count not found in dfInput"=all(c("SubjectID","SiteID", "Count") %in% names(dfInput)),
    "nThreshold must be numeric" = is.numeric(nThreshold),
    "nThreshold must be length 1" = length(nThreshold) ==1
  )

  lAssess <- list()
  lAssess$dfInput <- dfInput
  lAssess$dfTransformed <- gsm::Transform_EventCount( lAssess$dfInput, strCountCol = 'Count'  )
  lAssess$dfAnalyzed <-lAssess$dfTransformed %>% mutate(Estimate = .data$TotalCount)
  lAssess$dfFlagged <- gsm::Flag( lAssess$dfAnalyzed ,vThreshold = c(NA,nThreshold), strColumn = "TotalCount" )
  lAssess$dfSummary <- gsm::Summarize( lAssess$dfFlagged, strScoreCol="TotalCount", strAssessment="Main Consent", strLabel= strLabel)

  if(bDataList){
    return(lAssess)
  } else {
    return(lAssess$dfSummary)
  }
}

