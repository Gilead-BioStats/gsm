

#' Transform Event Count
#'
#' @param dfInput A data frame with one Record per person
#' @param cCountCol required. Column to be counted. "InvalidorMissing" = Invalid>0 | Missing > 0 for IE Assessment.
#' @param cExposureCol Optional, Exposure Column
#' @param cUnitCol Optional, Unit Column (currently unused)
#'
#' @return
#' @export
#'
Transform_EventCount <- function( dfInput , cCountCol=NULL, cExposureCol=NULL, cUnitCol=NULL){
    stopifnot(
        is.data.frame(dfInput)
    )
  
  dfTransformed <- dfInput  %>%
    group_by(SiteID) %>% 
    summarise(
      N=n(), TotalCount= 
        if(cCountCol == 'InvalidorMissing' ){
          sum(Invalid>0 | Missing > 0)
        }else{
          sum(.data[[cCountCol]])
        }
    ) 

    
    if(!is.null(cExposureCol)){
      dfExposure <- dfInput %>% 
        group_by(SiteID) %>%
        summarise(
          TotalExposure=sum(.data[[cExposureCol]]),
          Unit=first(Unit),
        )
      
      dfTransformed <- left_join(dfTransformed, dfExposure) %>%
        mutate(Rate = TotalCount/TotalExposure)
    }
    return(dfTransformed)
}


# Transform_EventCount
# 
# @param dfInput input data frame with one record per person containing the following columns - SiteID, Count, Exposure, Unit
# 
# @return dataframe one record per site and columns for Site ("SiteID"), Number of participants ("N"), Number of events ("TotalCount"),  Total Exposure ("TotalExposure"), Exposure per person ("Rate"), Unit of measure for exposure ("Unit").
# 
# @export