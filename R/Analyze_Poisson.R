#' AE Poisson Assessment - Analysis
#' 
#' Adds columns for site-level statistical assessment of distribution of reported safety outcomes
#'
#' @param dfTransformed frame in format produced by \code{\link{AE_Transform}}
#'
#' @return input data frame with the  columns added for "Residuals", "PredictedCount" and "PValue"
#' 
#' @export


Analyze_Poisson <- function( dfTransformed ){
    stopifnot(
        is.data.frame(dfTransformed), 
        all(c("SiteID", "N", "TotalExposure", "TotalCount", "Rate","Unit") %in% names(dfTransformed))    
    )

    dfTransformed$LogExposure <- log( dfTransformed$TotalExposure )

    cModel <- glm(
        TotalCount ~ stats::offset(LogExposure), family=poisson(link="log"), 
        data=dfTransformed
    )

    dfAnalyzed <- dfTransformed
    dfAnalyzed$Residuals <- residuals( cModel )
    dfAnalyzed$PredictedCount <- exp(dfAnalyzed$LogExposure*cModel$coefficients[2]+cModel$coefficients[1])
    dfAnalyzed$PValue = pnorm( abs(dfAnalyzed$Residuals) , lower.tail=F ) * 2
    dfAnalyzed <- dfAnalyzed[order(abs(dfAnalyzed$Residuals) , decreasing=T), ]

    return(dfAnalyzed)
}