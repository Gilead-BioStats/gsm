#' Consent - Transformed Input Data
#' 
#' DESCRIPTION
#'
#' @param dfInput 
#' 
#' @return  
#' 
#' @export

Consent_Transform <- function( dfInput ){
  dfTransformed <- dfInput  %>%
    group_by(SiteID) %>%
    summarise(
      N=n(),  
      Invalid=sum(any_flag)
    ) 
    
  return(dfTransformed)
}
