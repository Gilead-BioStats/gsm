#' Transform Event Count
#'
#' @param dfInput A data frame with one Record per person
#' @param cCountCol required. Column to be counted. "InvalidorMissing" = Invalid>0 | Missing > 0 for IE Assessment.
#' @param cExposureCol Optional, Exposure Column
#' @param cUnitCol Optional, Unit Column (currently unused)
#'
#' @export

Transform_EventCount <- function( dfInput , cCountCol=NULL, cExposureCol=NULL, cUnitCol=NULL){
    stopifnot(
        is.data.frame(dfInput)
    )
  
  dfTransformed <- dfInput  %>%
    group_by(.data$SiteID) %>% 
    summarise(
      N=n(), 
      TotalCount= 
        if(cCountCol == 'InvalidorMissing' ){
          sum(.data$Invalid>0 | .data$Missing > 0)
        }else{
          sum(.data[[cCountCol]])
        }
    ) 

    if(!is.null(cExposureCol)){
      dfExposure <- dfInput %>% 
        group_by(.data$SiteID) %>%
        summarise(
          TotalExposure=sum(.data[[cExposureCol]]),
          Unit=first(.data[[cUnitCol]])
        )
      
      dfTransformed <- left_join(dfTransformed, dfExposure) %>%
        mutate(Rate = .data$TotalCount/.data$TotalExposure)
    }

    return(dfTransformed)
}