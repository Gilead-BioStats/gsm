#' Transform_EventCount
#'
#' @param dfInput input data frame with one record per person containing the following columns - SiteID, Count, Exposure, Unit 
#'
#' @return dataframe one record per site and columns for Site ("SiteID"), Number of participants ("N"), Number of events ("TotalCount"),  Total Exposure ("TotalExposure"), Exposure per person ("Rate"), Unit of measure for exposure ("Unit").
#' 
#' @export

Transform_EventCount <- function( dfInput , cCountCol=NULL, cExposureCol=NULL, cUnitCol=NULL){
    stopifnot(
        is.data.frame(dfInput), 
        all(c("SiteID", "Count", "Exposure", "Unit" ) %in% names(dfInput))
    )

    dfTransformed <- dfInput  %>%
        group_by(SiteID) %>%
        summarise(
            N=n(),
            TotalCount=sum(.data[[cCountCol]])
         )
    if(!is.null(cExposureCol)){
        dfTransformed<- dfTransformed %>% 
            TotalExposure=sum(.data[[cExposureCol]]),
            Unit=first(Unit),
        ) %>%
        mutate(Rate = TotalCount/TotalExposure)
    }
    return(dfTransformed)
}
