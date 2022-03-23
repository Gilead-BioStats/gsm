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
#' @param dfInput input data with one record per person and the following required columns: SubjectID, SiteID, Count.
#' @param nThreshold Any sites where 'N' is greater than nThreshold will be flagged. Default value is 0.5, which flags any site with one or more subjects meeting any of the criteria.
#' @param lTags named list of tags describing the assessment. `lTags` is returned as part of the assessemnt (`lAssess$lTags`) and each tag is added as columns in `lassess$dfSummary`. Default is `list(Assessment="AE", Details="")`
#'
#' @examples
#'
#' library(dplyr)
#' raw_consent <- clindata::raw_ic_elig %>%
#' select(SUBJID, CONSDAT = DSSTDAT_RAW) %>%
#'  mutate(
#'      CONSCAT_STD = "MAINCONSENT",
#'      CONSYN = "Y",
#'      CONSDAT = as.Date(CONSDAT, format = "%d %B %Y")
#'    ) %>%
#'    filter(SUBJID != "")
#'
#' dfInput <- Consent_Map_Raw(
#'    dfConsent = raw_consent,
#'    dfRDSL = clindata::rawplus_rdsl,
#'    strConsentTypeValue = "MAINCONSENT",
#'    strConsentStatusValue="Y"
#' )
#'
#' Consent_Summary <- Consent_Assess(dfInput)$dfSummary
#'
#' @import dplyr
#'
#' @return A list containing all data and metadata in the standard data pipeline (`dfInput`, `dfTransformed`, `dfAnalyzed`, `dfFlagged`, `dfSummary`, `strFunctionName`, `lParams` and `lTags`) is returned.
#'
#' @export

Consent_Assess <- function( dfInput, nThreshold=0.5,  lTags=list(Assessment="Consent")){

  stopifnot(
    "dfInput is not a data.frame" = is.data.frame(dfInput),
    "One or more of these columns: SubjectID, SiteID,and Count not found in dfInput"=all(c("SubjectID","SiteID", "Count") %in% names(dfInput)),
    "nThreshold must be numeric" = is.numeric(nThreshold),
    "nThreshold must be length 1" = length(nThreshold) ==1
  )

  if(!is.null(lTags)){
      stopifnot(
          "lTags is not named"=(!is.null(names(lTags))),
          "lTags has unnamed elements"=all(names(lTags)!="")
      )
  }   

  lAssess <- list()
  lAssess$strFunctionName <- deparse(sys.call()[1])
  lAssess$lParams <- lapply(as.list(match.call()[-1]), function(x) as.character(x))
  lAssess$lTags <- lTags
  lAssess$dfInput <- dfInput
  lAssess$dfTransformed <- gsm::Transform_EventCount( lAssess$dfInput, strCountCol = 'Count'  )
  lAssess$dfAnalyzed <-lAssess$dfTransformed %>% mutate(Estimate = .data$TotalCount)
  lAssess$dfFlagged <- gsm::Flag( lAssess$dfAnalyzed ,vThreshold = c(NA,nThreshold), strColumn = "TotalCount" )
  lAssess$dfSummary <- gsm::Summarize( lAssess$dfFlagged, strScoreCol="TotalCount", lTags)

  return(lAssess)

}

