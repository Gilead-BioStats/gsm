#' Inclusion/Exclusion - Transformed Input Data
#' 
#' DESCRIPTION
#'
#' @param dfInput frame in format produced by \code{\link{IE_Map_Raw}}
#' 
#' @export

IE_Transform <- function( dfInput ){
  dfTransformed <- dfInput  %>%
    group_by(.data$SiteID) %>%
    summarise(
      N=n(),  
      Invalid=sum(.data$Invalid>0 | .data$Missing > 0)
    ) 
    
  return(dfTransformed)
}
