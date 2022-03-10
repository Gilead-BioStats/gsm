#' Protocol Deviation Assessment
#'
#' @details
#'
#' The Protocol Deviation Assessment uses the standard GSM data pipeline (TODO add link to data vignette) to flag possible outliers. More details regarding the data pipeline and statistical methods are described below.
#'
#' @section Data Specification:
#'
#' The input data (`dfInput`) for the PD Assessment is typically created using \code{\link{PD_Map_Raw}} and should be one record per person with columns for:
#' - `SubjectID` - Unique subject ID
#' - `SiteID` - Site ID
#' - `Count` - Number of protocol deviation events
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
#' A Poisson or Wilcoxon model is used to generate estimates and p-values for each site (as specified with the `strMethod` parameter). Those model outputs are then used to flag possible outliers using the thresholds specified in `vThreshold`. In the Poisson model, sites with an estimand less than -5 are flagged as -1 and greater than 5 are flagged as 1 by default. For Wilcoxon, sites with p-values less than 0.0001 are flagged by default.
#'
#' See \code{\link{Analyze_Poisson}} and \code{\link{Analyze_Wilcoxon}} for additional details about the statistical methods and thier assumptions.
#'
#' @param dfInput input data with one record per person and the following required columns: SubjectID, SiteID, Count, Exposure, Rate.
#' @param vThreshold list of threshold values default c(-5,5) for method = "poisson", c(.0001,NA) for method = Wilcoxon
#' @param strLabel Assessment label
#' @param strMethod valid methods are "poisson" (the default), or  "wilcoxon"
#'
#' @examples
#' dfInput <- PD_Map_Raw(dfPD = clindata::raw_protdev, dfRDSL = clindata::rawplus_rdsl)
#' SafetyPD <- PD_Assess( dfInput )
#' SafetyPD_Wilk <- PD_Assess( dfInput, strMethod="wilcoxon")
#'
#' @return A list containing all data and metadata in the standard data pipeline (`dfInput`, `dfTransformed`, `dfAnalyzed`, `dfFlagged`, `dfSummary`, `strFunctionName`, and `lParams`) is returned.
#'
#' @export

PD_Assess <- function(dfInput, vThreshold=NULL, strLabel="",strMethod="poisson"){
    stopifnot(
        "dfInput is not a data.frame" = is.data.frame(dfInput),
        "strLabel is not character" = is.character(strLabel),
        "Length of strLabel is not greater than 1" = length(strLabel) <=1 ,
        "strMethod is not 'poisson' or 'wilcoxon'" = strMethod %in% c("poisson","wilcoxon"),
        "strMethod must be length 1" = length(strMethod) == 1,
        "One or more of these columns: SubjectID, SiteID, Count, Exposure, and Rate not found in dfInput"=all(c("SubjectID","SiteID", "Count","Exposure", "Rate") %in% names(dfInput))
    )

    lAssess <- list()
    lAssess$strFunctionName <- deparse(sys.call()[1])
    lAssess$lParams <- lapply(as.list(match.call()[-1]), function(x) as.character(x))
    lAssess$dfInput <- dfInput
    lAssess$dfTransformed <- gsm::Transform_EventCount( lAssess$dfInput, strCountCol = "Count", strExposureCol = "Exposure")

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
        lAssess$dfSummary <- gsm::Summarize( lAssess$dfFlagged, strScoreCol="Residuals", strAssessment="Safety", strLabel= strLabel)

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
        lAssess$dfFlagged <- gsm::Flag( lAssess$dfAnalyzed ,  strColumn = 'PValue', vThreshold =vThreshold)
        lAssess$dfSummary <- gsm::Summarize( lAssess$dfFlagged, strAssessment="Safety", strLabel= strLabel)
    }

    return(lAssess)

}
