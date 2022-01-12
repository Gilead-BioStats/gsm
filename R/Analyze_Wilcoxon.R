#' AE_Wilcoxon_Analyze
#'
#' Creates Analyis results data for Adverse Event assessment using the Wilcoxon sign-ranked test
#'
#' @param  dfTransformed paramDescription 
#'
#' @export

AE_Wilcoxon_Analyze <- function(dfTransformed) {
    vSiteIndex <- unique( dfTransformed$SiteID )
    vStatistic <- rep( NA , length( vSiteIndex ) ) 
    vPValue <- rep( NA , length( vSiteIndex ) )
    dfSummary <- data.frame( matrix( NA , nrow = length( vSiteIndex ) , ncol = 8 ) )
    colnames(dfSummary) <- c( "N" , "Mean" , "SD", "Median", "Q1", "Q3", "Min", "Max" )

    for( i in 1:length( vSiteIndex ) ){
        #  Remove the warning with exact = FALSE
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

Analyze_Wilcoxon_SummarizeCtsData <- function( vData , nDigits = 3){
    vOutput <- c( 
        N = length( vData ) - sum( is.na( vData ) ) , 
        Mean = mean( vData , na.rm = T ) , SD = sd( vData , na.rm = T ),
        Median = median( vData , na.rm = T ), 
        Q1 = quantile( vData , 1/4 , type=2 , na.rm = T ), 
        Q3 = quantile( vData , 3/4 , type=2 , na.rm = T ),
        Min = min( vData , na.rm=T ) , Max = max( vData , na.rm=T ) 
    )
    vOutput <- round( vOutput , nDigits )
    return(vOutput)
}
