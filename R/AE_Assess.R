#' AE Assessment
#'
#' The Adverse Event Assessment flags sites that may be over- or under-reporting adverse events.
#'
#' @details
#'
#' The Adverse Event Assessment uses the standard GSM data pipeline (TODO add link to data vignette) to flag possible outliers. More details regarding the data pipeline and statistical methods are described below.
#'
#' @section Data Specification:
#'
#' The input data (`dfInput`) for the AE Assessment is typically created using \code{\link{AE_Map_Raw}} or \code{\link{AE_Map_Adam}} and should be one record per person with columns for:
#' - `SubjectID` - Unique subject ID
#' - `SiteID` - Site ID
#' - `Count` - Number of Adverse Events
#' - `Exposure` - Number of days of exposure
#' - `Rate` - Rate of Exposure (Count / Exposure)
#'
#' The Assessment
#' - \code{\link{Transform_EventCount}} creates `dfTransformed`.
#' - \code{\link{Analyze_Poisson}} or \code{\link{Analyze_Wilcoxon}} creates `dfAnalyzed`.
#' - \code{\link{Flag}} creates `dfFlagged`.
#' - \code{\link{Summarize}} creates `dfSummary`.
#'
#' @section Statistical Assumptions:
#'
#' A Poisson or Wilcoxon model is used to generate estimates and p-values for each site (as specified with the `strMethod` parameter). Those model outputs are then used to flag possible outliers using the thresholds specified in `vThreshold`. In the Poisson model, sites with an estimate less than -5 are flagged as -1 and greater than 5 are flagged as 1 by default. For Wilcoxon, sites with p-values less than 0.0001 are flagged by default.
#'
#' See \code{\link{Analyze_Poisson}} and \code{\link{Analyze_Wilcoxon}} for additional details about the statistical methods and their assumptions.
#'
#' @param dfInput input data with one record per person and the following required columns: SubjectID, SiteID, Count, Exposure.
#' @param vThreshold numeric vector with 2 threshold values.  Defaults to c(-5,5) for method = "poisson" and c(.0001,NA) for method = Wilcoxon.
#' @param strMethod valid methods are "poisson" (the default), or  "wilcoxon".
#' @param lTags named list of tags describing the assessment. `lTags` is returned as part of the assessment (`lAssess$lTags`) and each tag is added as columns in `lassess$dfSummary`. Default is `list(Assessment="AE")`.
#' @param bChart should visualization be created? TRUE (default) or FALSE.
#'
#' @examples
#' dfInput <- AE_Map_Adam( safetyData::adam_adsl, safetyData::adam_adae )
#' SafetyAE <- AE_Assess( dfInput )
#' SafetyAE_Wilk <- AE_Assess( dfInput, strMethod="wilcoxon")$dfSummary
#'
#' @return A list containing all data and metadata in the standard data pipeline (`dfInput`, `dfTransformed`, `dfAnalyzed`, `dfFlagged`, `dfSummary`, `strFunctionName`, `lParams` and `lTags`) is returned.
#'
#' @export

AE_Assess <- function(dfInput, vThreshold=NULL, strMethod="poisson", lTags=list(Assessment="AE"), bChart=TRUE){
    stopifnot(
        "dfInput is not a data.frame" = is.data.frame(dfInput),
        "strMethod is not 'poisson' or 'wilcoxon'" = strMethod %in% c("poisson","wilcoxon"),
        "One or more of these columns: SubjectID, SiteID, Count, Exposure, and Rate not found in dfInput"=all(c("SubjectID","SiteID", "Count","Exposure", "Rate") %in% names(dfInput)),
        "strMethod must be length 1" = length(strMethod) == 1
    )

    if(!is.null(lTags)){
        stopifnot(
            "lTags is not named"=(!is.null(names(lTags))),
            "lTags has unnamed elements"=all(names(lTags)!=""),
            "lTags cannot contain elements named: 'SiteID', 'N', 'Score', or 'Flag'" = !names(lTags) %in% c("SiteID", "N", "Score", "Flag")
        )
    }

    lAssess <- list(
        strFunctionName = deparse(sys.call()[1]),
        lParams = lapply(as.list(match.call()[-1]), function(x) as.character(x)),
        lTags = lTags,
        dfInput = dfInput
    )

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
        lAssess$dfSummary <- gsm::Summarize( lAssess$dfFlagged, strScoreCol = 'Residuals',lTags)
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
        lAssess$dfAnalyzed <- gsm::Analyze_Wilcoxon( lAssess$dfTransformed)
        lAssess$dfFlagged <- gsm::Flag( lAssess$dfAnalyzed ,  strColumn = 'PValue', vThreshold =vThreshold, strValueColumn = 'Estimate')
        lAssess$dfSummary <- gsm::Summarize( lAssess$dfFlagged, strScoreCol = 'PValue', lTags = lTags)
    }

    if (bChart) {
        if(strMethod=="poisson"){
            dfBounds <- Analyze_Poisson_PredictBounds(lAssess$dfTransformed)
            lAssess$chart <- Visualize_Scatter(lAssess$dfFlagged, dfBounds)
        }else{
            lAssess$chart <- Visualize_Scatter(lAssess$dfFlagged)
        }
    }

    return(lAssess)

}
