#' Disposition Assessment
#'
#' The Disposition Assessment flags sites that may be misrepresenting discontinuation reasons.
#'
#' @details
#'
#' The Disposition Assessment uses the standard GSM data pipeline (TODO add link to data vignette) to flag possible outliers. More details regarding the data pipeline and statistical methods are described below.
#'
#' @section Data Specification:
#'
#' The input data (`dfDisp`) for the Disposition Assessment is typically created using \code{\link{Disp_Map}} and should be one record per person with columns for:
#' - `SubjectID` - Unique subject ID
#' - `SiteID` - Site ID
#' - `Count` - Number of Discontinuation Reasons
#'
#' The Assessment
#' - \code{\link{Transform_EventCount}} creates `dfTransformed`.
#' - \code{\link{Analyze_Fisher}} or \code{\link{Analyze_Chisq}} creates `dfAnalyzed`.
#' - \code{\link{Flag}} creates `dfFlagged`.
#' - \code{\link{Summarize}} creates `dfSummary`.
#'
#' @section Statistical Assumptions:
#'
#' A Fisher's Exact or Chi-Square model is used to generate estimates and p-values for each site (as specified with the `strMethod` parameter). Those model outputs are then used to flag possible outliers using the thresholds specified in `vThreshold`. In the Fisher's Exact model, sites with an estimand less than -5 are flagged as -1 and greater than 5 are flagged as 1 by default. For Chi-Square, sites with p-values less than 0.0001 are flagged by default.
#'
#' See \code{\link{Analyze_Fisher}} and \code{\link{Analyze_Chisq}} for additional details about the statistical methods and thier assumptions.
#'
#' @param dfDisp input data with one record per person and the following required columns: SubjectID, SiteID, Count
#' @param vThreshold numeric vector with 2 threshold values.  Defaults to c(-5,5) for method = "fishers" and c(.0001,NA) for method = "chisquare".
#' @param strLabel Assessment label
#' @param strMethod valid methods are "fishers" (the default), or  "chisquare"
#'
#' @examples
#' dfInput <- Disp_Map( dfDisp = safetyData::adam_adsl, strReason = "adverse event" )
#' SafetyAE <- Disp_Assess( dfInput )
#' SafetyAE_Wilk <- Disp_Assess( dfInput, strMethod="chisquare" )
#'
#' @return A list containing all data and metadata in the standard data pipeline (`dfInput`, `dfTransformed`, `dfAnalyzed`, `dfFlagged`, `dfSummary`, `strFunctionName`, and `lParams`) is returned.
#'
#' @export
Disp_Assess <- function( dfDisp, vThreshold = NULL, strLabel = "", strMethod = "fishers") {
  stopifnot(
    "dfDisp is not a data.frame" = is.data.frame(dfDisp),
    "strLabel is not character" = is.character(strLabel),
    "strMethod is not 'fishers' or 'chisquare'" = strMethod %in% c("fishers", "chisquare"),
    "One or more of these columns: SubjectID, SiteID, or Count not found in dfDisp" =
      all(c("SubjectID", "SiteID", "Count") %in% names(dfDisp))
  )

  lAssess <- list()
  lAssess$strFunctionName <- deparse(sys.call()[1])
  lAssess$lParams <- lapply(as.list(match.call()[-1]), function(x) as.character(x))
  lAssess$dfDisp <- dfDisp
  lAssess$dfTransformed <- gsm::Transform_EventCount(lAssess$dfDisp, strCountCol = "Count")

  if(strMethod == "fishers") {
    if (is.null(vThreshold)) {
      vThreshold = c(-5, 5)
    } else{
      stopifnot(
        "vThreshold is not numeric" = is.numeric(vThreshold),
        "vThreshold for Fisher's contains NA values" = all(!is.na(vThreshold)),
        "vThreshold is not length 2" = length(vThreshold) == 2
      )
    }
  lAssess$dfAnalyzed <- gsm::Analyze_Fisher(lAssess$dfTransformed)
  lAssess$dfFlagged <-gsm::Flag(lAssess$dfAnalyzed, strColumn = 'Estimate', vThreshold = vThreshold)

  } else if (strMethod == "chisquare") {
    if (is.null(vThreshold)) {
      vThreshold = c(0.0001, NA)
    } else{
      stopifnot(
        "vThreshold is not numeric" = is.numeric(vThreshold),
        "Lower limit (first element) for Chi-Square vThreshold is not between 0 and 1" = vThreshold[1] <
          1 & vThreshold[1] > 0,
        "Upper limit (second element) for Chi-Square vThreshold is not NA" = is.na(vThreshold[2]),
        "vThreshold is not length 2" = length(vThreshold) == 2
      )
    }
    lAssess$dfAnalyzed <- gsm::Analyze_Chisq(lAssess$dfTransformed)
    lAssess$dfFlagged <- gsm::Flag(lAssess$dfAnalyzed, strColumn = 'Statistic', vThreshold = vThreshold)
  }

lAssess$dfSummary <- Summarize( lAssess$dfFlagged, strAssessment = "Disposition", strLabel = "")

  return(lAssess)

}
