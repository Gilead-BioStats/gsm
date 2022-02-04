#' AE Wilcoxon Assessment - Analysis
#'
#' Creates Analysis results data for Adverse Event assessment using the Wilcoxon sign-ranked test 
#'
#'  @details
#'  
#' Fits a Wilcox Model to site-level data. 
#' 
#' @section Statistical Methods:
#' 
#' TODO Coming soon ...
#' 
#' @section Data Specification:
#' 
#' The input data (` dfTransformed`) for the Analyze_Wilcoxon is typically created using \code{\link{Transform_EventCount}}  and should be one record per Site with columns for: 
#' - `SubjectID` - Unique subject ID
#' - `SiteID` - Site ID
#' - `Count` - Number of Adverse Events 
#' - `Exposure` - Number of days of exposure 
#' 
#'
#' @param  dfTransformed  data.frame in format produced by \code{\link{Transform_EventCount}} 
#'
#' @importFrom stats wilcox.test
#' 
#' @return data.frame with one row per site, columns:   SiteID, N , Mean, SD, Median, Q1,  Q3,  Min, Max, Statistic, PValue
#' 
#' @examples 
#' dfInput <- AE_Map_Adam( safetyData::adam_adsl, safetyData::adam_adae )
#' dfTransformed <- Transform_EventCount( dfInput, cCountCol = 'Count', cExposureCol = "Exposure" )
#' dfAnalyzed <- Analyze_Wilcoxon( dfTransformed ) 
#' 
#' @export

Analyze_Wilcoxon <- function(dfTransformed) {
  
    stopifnot(
      is.data.frame(dfTransformed), 
      all(c("SiteID", "N", "TotalExposure", "TotalCount", "Rate") %in% names(dfTransformed))    
    )
    vSiteIndex <- unique( dfTransformed$SiteID )
    vStatistic <- rep( NA , length( vSiteIndex ) ) 
    vPValue <- rep( NA , length( vSiteIndex ) )
    dfSummary <- data.frame( matrix( NA , nrow = length( vSiteIndex ) , ncol = 8 ) )
    colnames(dfSummary) <- c( "N" , "Mean" , "SD", "Median", "Q1", "Q3", "Min", "Max" )

    for( i in 1:length( vSiteIndex ) ){
        #Remove the warning with exact = FALSE
        lResults <- wilcox.test( dfTransformed$Rate ~ dfTransformed$SiteID == vSiteIndex[i], exact = FALSE)
        vStatistic[i] <- lResults$statistic
        vPValue[i] <- lResults$p.value
        dfSummary[i,] <- Analyze_Wilcoxon_SummarizeCtsData( dfTransformed$Rate[dfTransformed$SiteID == vSiteIndex[i]] )
    }

    dfAnalyzed <- data.frame( 
        SiteID = vSiteIndex , 
        dfSummary ,
        Statistic = vStatistic , 
        PValue = vPValue 
    )
    dfAnalyzed <- dfAnalyzed[ order( dfAnalyzed$PValue , decreasing = F ) , ]                         

return(dfAnalyzed)
}

#' SummarizeCtsData
#'
#' Helper function for Wilcoxon sign-ranked test
#' 
#' @param vData data vector
#' @param nDigits number of digits
#' 
#' @importFrom stats median sd quantile

Analyze_Wilcoxon_SummarizeCtsData <- function( vData , nDigits = 3){
    vOutput <- c( 
        N = length( vData ) - sum( is.na( vData ) ) , 
        Mean = mean( vData , na.rm = T ) , 
        SD = stats::sd( vData , na.rm = T ),
        Median = stats::median( vData , na.rm = T ), 
        Q1 = stats::quantile( vData , 1/4 , type=2 , na.rm = T ), 
        Q3 = stats::quantile( vData , 3/4 , type=2 , na.rm = T ),
        Min = min( vData , na.rm=T ) , Max = max( vData , na.rm=T ) 
    )
    vOutput <- round( vOutput , nDigits )
    return(vOutput)
}
