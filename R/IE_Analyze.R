#' Inclusion/Exclusion Assessment - Analyze
#' 
#' Analysis of Inclusion/Exclusion
#' 
#' @param dfTransformed frame in format produced by \code{\link{IE_Transform}}
#' 
#' @export

IE_Analyze <- function( dfTransformed ){

  # PValue is NA since any invalid IE data results in a flag
  # Estimate is the number of participants with 1+ mismatched IE assessments in a site
  dfAnalyzed <- dfTransformed %>% 
    mutate(PValue = NA) %>% 
    mutate(Estimate = .data$Invalid) 

  return(dfAnalyzed)
}