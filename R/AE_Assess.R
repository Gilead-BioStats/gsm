#' AE Assessment 
#' 
#' @param dfInput input data
#' @param lThreshold list of threshold values 
#' @param nCutoff optional parameter to control the auto-thresholding 
#' @param cLabel Assessment label 
#' @param method valid methods are "poisson" (the default), or  "wilcoxon" 
#' @param bDataList Should all assessment datasets be returned as a list? If False (the default), only the finding data frame is returned
#'
#' @examples 
#' dfInput <- AE_Map( safetyData::adam_adsl, safetyData::adam_adae )
#' SafetyAE <- AE_Assess( dfInput )
#' SafetyAE_Wilk <- AE_Assess( dfInput, method="wilcoxon")
#'
#' @return Finding data frame with columns for "SiteID", "N", "PValue", "Flag". 
#'
#' @export

AE_Assess <- function( dfInput, dThreshold=NULL, cLabel="", method="poisson", bDataList=FALSE){
    lAssess <- list()
    lAssess$dfInput <- dfInput
    lAssess$dfTransformed <- gsm::Transform_EventCount( lAssess$dfInput )
    if(method == "poisson"){
        lAssess$dfAnalyzed <- gsm::Analyze_Poisson( lAssess$dfTransformed) 
        lAssess$dfFlagged <- gsm::Flag( lAssess$dfAnalyzed , strColumn = 'Residuals', vThreshold =c(-5,5))
    } else if(method=="wilcoxon"){
        lAssess$dfAnalyzed <- gsm::Analyze_Wilcoxon( lAssess$dfTransformed) 
        lAssess$dfFlagged <- gsm::Flag( lAssess$dfAnalyzed ,  strColumn = 'PValue', vThreshold =c(0.0001,NA))
    }
    
    lAssess$dfSummary <- gsm::Summarize( lAssess$dfFlagged, cAssessment="Safety", cLabel= cLabel)

    if(bDataList){
        return(lAssess)
    } else {
        return(lAssess$dfSummary)
    }
}
