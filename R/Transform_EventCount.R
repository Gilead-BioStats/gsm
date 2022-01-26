#' Transform Event Count
#'
#' @param dfInput A data frame with one Record per person
#' @param cCountCol required. Column to be counted. "InvalidorMissing" = Invalid>0 | Missing > 0 for IE Assessment.
#' @param cExposureCol Optional, Exposure Column
#' @param cUnitCol Optional, Unit Column (currently unused)
#'
#' @export

Transform_EventCount <- function( dfInput , cCountCol, cExposureCol=NULL, cUnitCol=NULL){
    stopifnot(
        is.data.frame(dfInput),
        cCountCol %in% names(dfInput),
        is.numeric(dfInput[[cCountCol]]),
        is.null(cExposureCol) | cExposureCol %in% names(dfInput),
        is.null(cExposureCol) | is.numeric(dfInput[[cExposureCol]]),
        is.null(cUnitCol) |  cUnitCol %in% names(dfInput),
        is.null(cUnitCol) | is.character(dfInput[[cUnitCol]])
    )
    
  
  dfTransformed <- dfInput  %>%
    group_by(.data$SiteID) %>% 
    summarise(
      N=n(), 
      TotalCount= sum(.data[[cCountCol]]),
      TotalExposure=if_else(
        is.null(cExposureCol),
        NA_real_,
        sum(.data[[cExposureCol]])
      ),
      Unit=if_else(
        is.null(cUnitCol),
        NA_real_,
        first(.data[[cUnitCol]])
      )
    )%>%  
    mutate(Rate = if_else(
      is.null(cExposureCol),
      NA_real_,
      .data$TotalCount/.data$TotalExposure,
    ))

    if(is.null(cExposureCol)){
      dfTransformed <- dfTransformed %>% select(-.data$TotalExposure,-.data$Unit, -.data$Rate)
    }
  
    return(dfTransformed)
}