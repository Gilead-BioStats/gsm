#' Safety Assessment Mapping from Raw Data- Make Input Data
#' 
#' Convert from raw data format to needed input format for Safety Assessment
#' Requires the following raw datasets: subid, ex, ae, da (optional)
#'
#' @param dfAe AE dataset with columns SUBJID and rows for each AE record
#' @param dfExposure exposure dataset calculated via \code{\link{Transform_Exposure}}
#' 
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count, Exposure, Rate, Unit
#' 
#' 
#' @export

AE_Map_Raw <- function( dfAE = NULL, dfExposure = NULL){
    stopifnot(
        "ae dataset not found"=is.data.frame(dfAE),
        "exposure dataset is not found"=is.data.frame(dfExposure),
        "USUBJID column not found in dfAE"="USUBJID" %in% names(dfAE),
        "SubjectID, SiteID, Exposure and columns not found in dfExposure"=all(c("SubjectID","SiteID","Exposure") %in% names(dfAE))
    )

    dfInput <-  dfExposure %>% 
        rowwise() %>%
        mutate(Count =sum(dfADAE$USUBJID==.data$SubjectID)) %>% 
        mutate(Rate = .data$Count/.data$Exposure) %>%
        select(.data$SubjectID,.data$SiteID, .data$Count, .data$Exposure, .data$Rate, .data$Unit)
        
    return(dfInput)
}