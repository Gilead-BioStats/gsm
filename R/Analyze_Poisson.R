#' AE Poisson Assessment - Analysis
#' 
#' Adds columns for site-level statistical assessment of distribution of reported safety outcomes
#' 
#' @details
#'
#' Fits a Poisson Model to site-level data. 
#' 
#' @section Statistical Methods:
#' 
#' TODO Coming soon ...
#' 
#' @section Data Specification: 
#' 
#' The input data (` dfTransformed`) for the Analyze_Poisson is typically created using \code{\link{Transform_EventCount}} and should be one record per Site with columns for: 
#' - `SubjectID` - Unique subject ID
#' - `SiteID` - Site ID
#' - `TotalCount` - Number of Events 
#' - `TotalExposure` - Number of days of exposure 
#'
#' @param dfTransformed data.frame in format produced by \code{\link{Transform_EventCount}}. Must include
#'
#' @importFrom stats glm offset poisson pnorm
#' @importFrom broom augment
#' 
#' @return input data frame with columns added for "Residuals", "PredictedCount" and "PValue"
#' 
#' @examples 
#' dfInput <- AE_Map_Adam( safetyData::adam_adsl, safetyData::adam_adae )
#' dfTransformed <- Transform_EventCount( dfInput, cCountCol = 'Count', cExposureCol = "Exposure" )
#' dfAnalyzed <- Analyze_Poisson( dfTransformed ) 
#' 
#' @export


Analyze_Poisson <- function( dfTransformed ){
    stopifnot(
        is.data.frame(dfTransformed), 
        all(c("SiteID", "N", "TotalExposure", "TotalCount", "Rate") %in% names(dfTransformed))    
    )

    dfModel <- dfTransformed %>% mutate(LogExposure = log( .data$TotalExposure) )

    cModel <- stats::glm(
        TotalCount ~ stats::offset(LogExposure), family=stats::poisson(link="log"), 
        data=dfModel
    )

    dfAnalyzed <- broom::augment(cModel, dfModel, type.predict = "response") %>% 
    rename(
        Residuals=.data$.resid, 
        PredictedCount=.data$.fitted,
    ) %>%
    mutate(PValue = stats::pnorm( abs(.data$Residuals) , lower.tail=F ) * 2) %>%
    arrange(.data$Residuals)

    # Note that the PValue calculation is a non-standard approximation and might be more accurately labeled a "standardized estimate" rather than a formal p-value.

    return(dfAnalyzed)
}
