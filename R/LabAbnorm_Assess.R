#' Lab Abnormality Assessment

#' The Lab Abnormality Assessment flags sites that may be reporting abnormal lab results.
#'
#' @details
#'
#' The Lab Abnormality Assessment uses the standard GSM data pipeline (TODO add link to data vignette) to flag possible outliers. More details regarding the data pipeline and statistical methods are described below.
#'
#' @section Data Specification:
#'
#' The input data (`dfInput`) for the Lab Abnormality Assessment is typically created using {LabAbnorm_Map_Raw} or \code{\link{LabAbnorm_Map_Adam}} and should be one record per person with columns for:
#' - `SubjectID` - Unique subject ID
#' - `SiteID` - Site ID
#' - `Count` - Number of Lab Abnormality events
#' - `Exposure` - Number of days of exposure
#'
#' The Assessment
#' - \code{\link{Transform_EventCount}} creates `dfTransformed`.
#' - \code{\link{Analyze_Poisson}} or \code{\link{Analyze_Wilcoxon}} creates `dfAnalyzed`.
#' - \code{\link{Flag}} creates `dfFlagged`.
#' - \code{\link{Summarize}} creates `dfSummary`.
#'
#' @section Statistical Assumptions:
#'
#' A Poisson or Wilcoxon model is used to generate estimates and p-values for each site (as specified with the `strMethod` parameter). Those model outputs are then used to flag possible outliers using the thresholds specified in `vThreshold`. In the Poisson model, sites with an estimand less than -5 are flagged as -1 and greater than 5 are flagged as 1 by default. For Wilcoxon, sites with p-values less than 0.0001 are flagged by default.
#'
#' See \code{\link{Analyze_Poisson}} and \code{\link{Analyze_Wilcoxon}} for additional details about the statistical methods and their assumptions.
#'
#' @param dfInput input data with one record per person and the following required columns: SubjectID, SiteID, Count, Exposure
#' @param vThreshold numeric vector with 2 threshold values.  Defaults to c(-5,5) for method = "poisson" and c(.0001,NA) for method = Wilcoxon.
#' @param strMethod valid methods are "poisson" (the default), or  "wilcoxon"
#' @param lTags named list of tags describing the assessment. `lTags` is returned as part of the assessment (`lAssess$lTags`) and each tag is added as columns in `lassess$dfSummary`. Default is `list(Assessment="AE")`.
#' 
#' @examples
#' dfInput <- LabAbnorm_Map_Adam( safetyData::adam_adsl, safetyData::adam_adlbc )
#' LabAbnorm_Summary <- LabAbnorm_Assess( dfInput )$dfSummary
#' 
#'
#' @return If `bDataList` is false (the default), the summary data frame (`dfSummary`) is returned. If `bDataList` is true, a list containing all data in the standard data pipeline (`dfInput`, `dfTransformed`, `dfAnalyzed`, `dfFlagged` and `dfSummary`) is returned.
#'
#' @export

LabAbnorm_Assess <-function( dfInput, vThreshold=NULL, strMethod="poisson",lTags=list(Assessment="AE")){
  
  
  
  stopifnot(
    "dfInput is not a data.frame" = is.data.frame(dfInput),
    "strMethod is not 'poisson' or 'wilcoxon'" = strMethod %in% c("poisson","wilcoxon"),
    "One or more of these columns: SubjectID, SiteID, Count, Exposure, and Rate not found in dfInput"=all(c("SubjectID","SiteID", "Count","Exposure", "Rate") %in% names(dfInput)),
    "strMethod must be length 1" = length(strMethod) == 1
  )
  lAssess <- list()
  lAssess$dfInput <- dfInput
  lAssess$dfTransformed <- gsm::Transform_EventCount( lAssess$dfInput, strCountCol = 'Count', strExposureCol = "Exposure" )
  if(strMethod == "poisson"){
    if(is.null(vThreshold)){
      vThreshold = c(-5,5)
    }else{
      stopifnot(
        "vThreshold is not numeric"=is.numeric(vThreshold),
        "vThreshold for Poisson contains NA values"=all(!is.na(vThreshold)),
        "vThreshold is not length 2"=length(vThreshold)==2
      )
    }
    lAssess$dfAnalyzed <- gsm::Analyze_Poisson( lAssess$dfTransformed)
    lAssess$dfFlagged <- gsm::Flag( lAssess$dfAnalyzed , strColumn = 'Residuals', vThreshold =vThreshold)
    lAssess$dfSummary <- gsm::Summarize( lAssess$dfFlagged, strScoreCol = 'Residuals', lTags = lTags)
    
  } else if(strMethod=="wilcoxon"){
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
    lAssess$dfAnalyzed <- gsm::Analyze_Wilcoxon( lAssess$dfTransformed , strOutcome = "Rate" )
    lAssess$dfFlagged <- gsm::Flag( lAssess$dfAnalyzed ,  strColumn = 'PValue', vThreshold =vThreshold, strValueColumn = 'Estimate')
    lAssess$dfSummary <- gsm::Summarize( lAssess$dfFlagged,  lTags = lTags)
  }
  
  

  return(lAssess)

}