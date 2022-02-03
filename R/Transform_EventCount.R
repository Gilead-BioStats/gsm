#' Transform Event Count
#'
#' @param dfInput A data frame with one Record per person
#' @param cCountCol required. numerical or logical. Column to be counted.
#' @param cExposureCol Optional, numerical Exposure Column
#' 
#' @examples 
#' dfInput <- AE_Map_Adam( safetyData::adam_adsl, safetyData::adam_adae )
#' dfTransformed <- Transform_EventCount( dfInput, cCountCol = 'Count', cExposureCol = "Exposure" )
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