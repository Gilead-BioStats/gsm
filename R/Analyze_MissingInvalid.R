#' Inclusion/Exclusion or Consent Assessment.
#' 
#' Analysis of Inclusion/Exclusion or Consent.
#' 
#' This analysis is for IE and Consent Assessments. It simply duplicates the TotalCount column of the input as Estimate which keeps the naming convention consistent for the subsequent Flag 
#' and summary functions as well as overall reporting consistency. PValue is not used for this assessment so all rows for PVAlue are set to NA.
#' 
#' @section Data Specification: 
#' 
#' The input data (` dfTransformed`) for IE_Analyze or Consent_Analyze is typically created using \code{\link{Transform_EventCount}} and should be one record per Site with columns for: 
#' - `SubjectID` - Unique subject ID
#' - `SiteID` - Site ID
#' - `TotalCount` - Number of Missing or Invalid
#'
#' @param dfTransformed data.frame in format produced by \code{\link{Transform_EventCount}}. Must include: SubjectID, SiteID, TotalCount.
#'
#' 
#' @return input data frame with columns added for "PValue" and "Estimate" (with all rows in PValue = NA).
#' 
#' @examples 
#' dfInput <- IE_Map_Raw(clindata::raw_ie_a2 )
#' 
#' dfTransformed <- gsm::Transform_EventCount( dfInput, cCountCol = "Count")
#' dfAnalyzed <- gsm::Analyze_MissingInvalid( dfTransformed ) 
#' 
#' 
#' 
#' @export

Analyze_MissingInvalid <- function( dfTransformed ){
  
  stopifnot(
    is.data.frame(dfTransformed), 
    all(c("SiteID", "N",  "TotalCount") %in% names(dfTransformed))    
  )

  # PValue is NA since any invalid IE data results in a flag
  # Estimate is the number of participants with 1+ mismatched IE assessments in a site
  dfAnalyzed <- dfTransformed %>% 
    mutate(PValue = NA) %>% 
    mutate(Estimate = .data$TotalCount) 

  return(dfAnalyzed)
}