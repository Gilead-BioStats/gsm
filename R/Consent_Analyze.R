#' Inclusion/Exclusion Assessment - Analyze
#' 
#' Analysis of Inclusion/Exclusion
#' 
#' @param dfTransformed frame in format produced by \code{\link{Transform_EventCount}}
#' 
#' @export

Consent_Analyze <- function( dfTransformed ){

  # PValue is NA since any invalid consent data results in a flag
  # Estimate is the number of participants with consent issues in a site
  dfAnalyzed <- dfTransformed %>% 
    mutate(PValue = NA) %>% 
    mutate(Estimate = .data$TotalCount) 


  return(dfAnalyzed)
}