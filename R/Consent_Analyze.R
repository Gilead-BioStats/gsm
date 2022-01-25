#' Inclusion/Exclusion Assessment - Analyze
#' 
#' Analysis of Inclusion/Exclusion
#' 
#' @param dfTransformed
#'
#' @return 
#' 
#' @export

Consent_Analyze <- function( dfTransformed ){

  # PValue is NA since any invalid consent data results in a flag
  # Estimate is the number of participants with consent issues in a site
  dfAnalyzed <- dfTransformed %>% 
    mutate(PValue = NA) %>% 
    mutate(Estimate = Invalid) 

  return(dfAnalyzed)
}