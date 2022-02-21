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
#' - \code{\link{Analyze_Poisson}} or \code{\link{Analyze_Wilcoxon}} creates `dfAnalyzed`.
#' - \code{\link{Flag}} creates `dfFlagged`.
#' - \code{\link{Summarize}} creates `dfSummary`.
#'
#' @section Statistical Assumptions:
#'
#' A Poisson or Wilcoxon model is used to generate estimates and p-values for each site (as specified with the `cMethod` parameter). Those model outputs are then used to flag possible outliers using the thresholds specified in `vThreshold`. In the Poisson model, sites with an estimand less than -5 are flagged as -1 and greater than 5 are flagged as 1 by default. For Wilcoxon, sites with p-values less than 0.0001 are flagged by default.
#'
#' See \code{\link{Analyze_Poisson}} and \code{\link{Analyze_Wilcoxon}} for additional details about the statistical methods and thier assumptions.
#'
#' @param dfDisp input data with one record per person and the following required columns: SubjectID, SiteID, Count
#' @param vThreshold numeric vector with 2 threshold values.  Defaults to c(-5,5) for method = "poisson" and c(.0001,NA) for method = "wilcoxon".
#' @param cLabel Assessment label
#' @param cMethod valid methods are "poisson" (the default), or  "wilcoxon"
#' @param bDataList Should all assessment datasets be returned as a list? If False (the default), only the Summary data frame is returned
#'
#' @examples
#' dfInput <- Disp_Map(dfDisp = safetyData::adam_adsl,strCol = "DCREASCD",strReason = "adverse event")
#' SafetyAE <- Disp_Assess( dfInput )
#' SafetyAE_Wilk <- Disp_Assess( dfInput, cMethod="wilcoxon")
#'
#' @return If `bDataList` is false (the default), the summary data frame (`dfSummary`) is returned. If `bDataList` is true, a list containing all data in the standard data pipeline (`dfInput`, `dfTransformed`, `dfAnalyzed`, `dfFlagged` and `dfSummary`) is returned.
#'
#' @export
Disp_Assess <- function( dfDisp, vThreshold = NULL, cLabel = "", cMethod = "wilcoxon", bDataList = FALSE) {
  stopifnot(
    "dfDisp is not a data.frame" = is.data.frame(dfDisp),
    "cLabel is not character" = is.character(cLabel),
    "cMethod is not 'poisson' or 'wilcoxon'" = cMethod %in% c("poisson","wilcoxon"),
    "bDataList is not logical" = is.logical(bDataList)
  )

lAssess <- list()
lAssess$dfDisp <- dfDisp
lAssess$dfTransformed <- gsm::Transform_EventCount( lAssess$dfDisp, cCountCol = "Count") %>%
  mutate(TotalExposure = NA,
         Rate = NA)

if(cMethod == "poisson"){
  if(is.null(vThreshold)){
    vThreshold = c(-5,5)
  }else{
    stopifnot(
      "vThreshold is not numeric"=is.numeric(vThreshold),
      "vThreshold for Poisson contains NA values"=all(!is.na(vThreshold)),
      "vThreshold is not length 2"=length(vThreshold)==2
    )
  }


  # wilcoxon is placeholder for now
  lAssess$dfAnalyzed <- gsm::Analyze_Wilcoxon( lAssess$dfTransformed, strOutcome = "TotalCount")
  lAssess$dfFlagged <- gsm::Flag( lAssess$dfAnalyzed , strColumn = 'Estimate', vThreshold =vThreshold)
} else if(cMethod=="wilcoxon"){
  if(is.null(vThreshold)){
    vThreshold = c(0.0001,NA)
  }else{
    stopifnot(
      "vThreshold is not numeric"=is.numeric(vThreshold),
      "Lower limit (first element) for Wilcoxon vThreshold is not between 0 and 1"= vThreshold[1]<1 & vThreshold[1]>0,
      "Upper limit (second element) for Wilcoxon vThreshold is not NA"= is.na(vThreshold[2]),
      "vThreshold is not length 2"=length(vThreshold)==2
    )
  }
  lAssess$dfAnalyzed <-gsm::Analyze_Wilcoxon( lAssess$dfTransformed, strOutcome = "TotalCount")
  lAssess$dfFlagged <- gsm::Flag( lAssess$dfAnalyzed ,  strColumn = 'Estimate', vThreshold =vThreshold, strValueColumn = 'PValue')
}

lAssess$dfSummary <- Summarize( lAssess$dfFlagged, cAssessment = "Disposition", cLabel = )

if(bDataList){
  return(lAssess)
} else {
  return(lAssess$dfSummary)
}

}
