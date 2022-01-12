#' Protocol Deviation Assessment using Poisson Regression
#' 
#' @param dfInput input data
#' @param lThreshold list of threshold values 
#' @param nCutoff optional parameter to control the auto-thresholding 
#' @param cLabel Assessment label 
#' @param bDataList Should all assessment datasets be returned as a list? If False (the default), only the finding data frame is returned
#'
#' @return Finding data frame with columns for "SiteID", "N", "PValue", "Flag". 
#' 
#' @export

PD_Assess <- function( dfInput, lThreshold=NULL, nCutoff=1, cLabel="", bDataList=FALSE){
    lAssess <- list()
    lAssess$dfInput <- dfInput
    lAssess$dfTransformed <- gsm::PD_Transform( lAssess$dfInput )
    lAssess$dfAnalyzed <- gsm::AE_Poisson_Analyze( lAssess$dfTransformed ) 
    if(is.null(lThreshold)){
        lThreshold <- AE_Poisson_Autothreshold(lAssess$dfAnalyzed$Residuals , nCutoff)
    }
    lAssess$dfFlagged <- gsm::AE_Poisson_Flag( lAssess$dfAnalyzed , lThreshold$ThresholdHi, lThreshold$ThresholdLo)
    lAssess$dfSummary <- gsm::AE_Summarize( lAssess$dfFlagged, cAssessment="Protocol Deviations", cLabel= cLabel)

    if(bDataList){
        return(lAssess)
    } else {
        return(lAssess$dfSummary)
    }
}
