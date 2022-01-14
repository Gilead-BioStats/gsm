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
    lAssess$dfTransformed <- gsm::Transform_EventCount( lAssess$dfInput )
    lAssess$dfAnalyzed <- gsm::Analyze_Poisson( lAssess$dfTransformed) 
    lAssess$dfFlagged <- gsm::Flag( lAssess$dfAnalyzed , strColumn = 'Residuals', vThreshold =c(-5,5)) 
    lAssess$dfSummary <- gsm::Summarize( lAssess$dfFlagged, cAssessment="Safety", cLabel= cLabel)

    if(bDataList){
        return(lAssess)
    } else {
        return(lAssess$dfSummary)
    }
}
