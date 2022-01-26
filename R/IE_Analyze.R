#' Inclusion/Exclusion Assessment - Analyze
#' 
#' Analysis of Inclusion/Exclusion
#' 
#' @param dfTransformed
#'
#' @return 
#' 
#' @export

IE_Analyze <- function( dfTransformed ){

  # PValue is NA since any invalid IE data results in a flag
  # Estimate is the number of participants with 1+ mismatched IE assessments in a site
  dfAnalyzed <- dfTransformed %>% 
    mutate(PValue = NA) %>% 
    mutate(Estimate = TotalCount) 

  return(dfAnalyzed)
}