#' Inclusion/Exclusion Assessment 
#' 
#' @param dfInput input dataset with subject information containing : (required variables)
#' @param nThreshold threshold values Flagging, integer values greater than will be flagged.
#' @param cLabel Assessment label 
#' @param bDataList Should all assessment datasets be returned as a list? If False (the default), only the finding data frame is returned
#'
#' @return Finding data frame with columns for "SiteID", "N", "PValue", "Flag". 
#' 
#' @export

IE_Assess <- function( dfInput, nThreshold=0.5,  cLabel="", bDataList=FALSE){
  lAssess <- list()
  lAssess$dfInput <- dfInput
  lAssess$dfTransformed <- gsm::IE_Transform( lAssess$dfInput )
  lAssess$dfAnalyzed <- gsm::IE_Analyze( lAssess$dfTransformed ) 
  lAssess$dfFlagged <- gsm::Flag( lAssess$dfAnalyzed , vThreshold = c(NA,nThreshold), strColumn = "Estimate" )
  lAssess$dfSummary <- gsm::Summarize( lAssess$dfFlagged, cAssessment="Inclusion/Exclusion", cLabel= cLabel)
  
  if(bDataList){
    return(lAssess)
  } else {
    return(lAssess$dfSummary)
  }
}

