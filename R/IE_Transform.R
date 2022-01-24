#' Inclusion/Exclusion - Transformed Input Data
#' 
#' DESCRIPTION
#'
#' @param dfInput 
#' 
#' @return  
#' 
#' @export

IE_Transform <- function( dfInput ){
  dfTransformed <- dfInput  %>%
    group_by(SiteID) %>%
    summarise(
      N=n(),  
      Invalid=sum(Invalid>0 | Missing > 0)
    ) 
    
  return(dfTransformed)
}
