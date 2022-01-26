#' Transform_EventCount
#'
#' @param dfInput input data frame with one record per person containing the following columns - SiteID, Count, Exposure, Unit 
#'
#' @return dataframe one record per site and columns for Site ("SiteID"), Number of participants ("N"), Number of events ("TotalCount"),  Total Exposure ("TotalExposure"), Exposure per person ("Rate"), Unit of measure for exposure ("Unit").
#' 
#' @export

Transform_EventCount <- function( dfInput ){
    stopifnot(
        is.data.frame(dfInput), 
        all(c("SiteID", "Count", "Exposure", "Unit" ) %in% names(dfInput))
    )

    dfTransformed <- dfInput  %>%
        group_by(.data$SiteID) %>%
        summarise(
            N=n(),
            TotalCount=sum(.data$Count),  
            TotalExposure=sum(.data$Exposure),
            Unit=first(.data$Unit),
        ) %>%
        mutate(Rate = .data$TotalCount/.data$TotalExposure)
    
    return(dfTransformed)
}