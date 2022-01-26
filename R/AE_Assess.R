#' AE Assessment 
#' 
#' @param dfInput input data
#' @param vThreshold numeric vector with 2 threshold values.  Defaults to c(-5,5) for method = "poisson" and c(.0001,NA) for method = Wilcoxon
#' @param cLabel Assessment label 
#' @param cMethod valid methods are "poisson" (the default), or  "wilcoxon" 
#' @param bDataList Should all assessment datasets be returned as a list? If False (the default), only the finding data frame is returned
#'
#' @examples 
#' dfInput <- AE_Map( safetyData::adam_adsl, safetyData::adam_adae )
#' SafetyAE <- AE_Assess( dfInput )
#' SafetyAE_Wilk <- AE_Assess( dfInput, cMethod="wilcoxon")
#'
#' @return Finding data frame with columns for "SiteID", "N", "PValue", "Flag". 
#'
#' @export

AE_Assess <- function( dfInput, vThreshold=NULL, cLabel="", cMethod="poisson", bDataList=FALSE){
    stopifnot(
        "dfInput is not a data.frame" = is.data.frame(dfInput),
        "cLabel is not character" = is.character(cLabel),
        "cMethod is not 'poisson' or 'wilcoxon'" = cMethod %in% c("poisson","wilcoxon"),
        "bDataList is not logical" = is.logical(bDataList)
    )
    lAssess <- list()
    lAssess$dfInput <- dfInput
    lAssess$dfTransformed <- gsm::Transform_EventCount( lAssess$dfInput )
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
        lAssess$dfAnalyzed <- gsm::Analyze_Poisson( lAssess$dfTransformed) 
        lAssess$dfFlagged <- gsm::Flag( lAssess$dfAnalyzed , strColumn = 'Residuals', vThreshold =vThreshold)
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
        lAssess$dfAnalyzed <- gsm::Analyze_Wilcoxon( lAssess$dfTransformed ) 
        lAssess$dfFlagged <- gsm::Flag( lAssess$dfAnalyzed ,  strColumn = 'PValue', vThreshold =vThreshold)
    }
    
    lAssess$dfSummary <- gsm::Summarize( lAssess$dfFlagged, cAssessment="Safety", cLabel= cLabel)

    if(bDataList){
        return(lAssess)
    } else {
        return(lAssess$dfSummary)
    }
}
