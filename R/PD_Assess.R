#' Protocol Deviation Assessment using Poisson Regression
#' 
#' @param dfInput input data 
#' @param vThreshold list of threshold values default c(-5,5) for method = "poisson", c(.0001,NA) for method = Wilcoxon
#' @param nCutoff optional parameter to control the auto-thresholding 
#' @param cLabel Assessment label 
#' @param method valid methods are "poisson" (the default), or  "wilcoxon" 
#' @param bDataList Should all assessment datasets be returned as a list? If False (the default), only the finding data frame is returned
#'
#' @return Finding data frame with columns for "SiteID", "N", "PValue", "Flag". 
#' 
#' @export

PD_Assess <- function( dfInput, vThreshold=NULL, nCutoff=1, cLabel="",method="poisson", bDataList=FALSE){
    lAssess <- list()
    lAssess$dfInput <- dfInput
    lAssess$dfTransformed <- gsm::Transform_EventCount( lAssess$dfInput )
    
    if(method == "poisson"){
      if(is.null(vThreshold))vThreshold = c(-5,5)
      lAssess$dfAnalyzed <- gsm::Analyze_Poisson( lAssess$dfTransformed) 
      lAssess$dfFlagged <- gsm::Flag( lAssess$dfAnalyzed , strColumn = 'Residuals', vThreshold =vThreshold)
    } else if(method=="wilcoxon"){
      if(is.null(vThreshold))vThreshold = c(0.0001,NA)
      lAssess$dfAnalyzed <- gsm::Analyze_Wilcoxon( lAssess$dfTransformed) 
      lAssess$dfFlagged <- gsm::Flag( lAssess$dfAnalyzed ,  strColumn = 'PValue', vThreshold =vThreshold)
    }
    
  
    lAssess$dfSummary <- gsm::Summarize( lAssess$dfFlagged, cAssessment="Safety", cLabel= cLabel)

    if(bDataList){
        return(lAssess)
    } else {
        return(lAssess$dfSummary)
    }
}
