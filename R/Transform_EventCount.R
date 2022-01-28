#' Transform Event Count
#'
#' @param dfInput A data frame with one Record per person
#' @param cCountCol required. Column to be counted. "InvalidorMissing" = Invalid>0 | Missing > 0 for IE Assessment.
#' @param cExposureCol Optional, Exposure Column
#'
#' @export

Transform_EventCount <- function( dfInput , cCountCol, cExposureCol=NULL ){
    stopifnot(
        is.data.frame(dfInput),
        cCountCol %in% names(dfInput),
        is.numeric(dfInput[[cCountCol]]) | is.logical(dfInput[[cCountCol]]),
        is.null(cExposureCol) | cExposureCol %in% names(dfInput)
    )
    if(!is.null(cExposureCol)) stopifnot(is.numeric(dfInput[[cExposureCol]]))
    
  if(is.null(cExposureCol)){
    dfTransformed <- dfInput  %>%
      group_by(.data$SiteID) %>% 
      summarise(
        N=n(), 
        TotalCount= sum(.data[[cCountCol]]),
      )
  }else{
    dfTransformed <- dfInput  %>%
      group_by(.data$SiteID) %>% 
      summarise(
        N=n(), 
        TotalCount= sum(.data[[cCountCol]]),
        TotalExposure=sum(.data[[cExposureCol]])
      )%>% 
      mutate(Rate = .data$TotalCount/.data$TotalExposure)
  }

  return(dfTransformed)
}