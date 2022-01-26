#' Consent - Transformed Input Data
#' 
#' DESCRIPTION
#'
#' @param dfInput frame in format produced by \code{\link{Consent_Map_Raw}}
#' 
#' @export

Consent_Transform <- function( dfInput ){
  dfTransformed <- dfInput  %>%
    group_by(.data$SiteID) %>%
    summarise(
      N=n(),  
      Invalid=sum(.data$any_flag)
    ) 
    
  return(dfTransformed)
}
