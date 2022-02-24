#' Transform Event Count
#' 
#' Convert from ADaM format to needed input format for Safety Assessment
#' @details
#'  
#' This function transforms data to prepare it for the Analysis step
#' 
#' @section Data Specification:
#' 
#' The input data (`dfInput`) for the AE Assessment is typically created using any of these functions:
#'  \code{\link{AE_Map_Raw}}
#'  \code{\link{AE_Map_Adam}} 
#'  \code{\link{PD_Map_Raw}} 
#'  \code{\link{IE_Map_Raw}} 
#'  \code{\link{Consent_Map_Raw}} 
#'  
#' (`dfInput`) has the following required and optional columns:
#' Required:
#' - `SiteID` - Site ID
#' - `Count` - Number of Adverse Events the actual name of this column is specified by the parameter cCountCol.
#' Optional
#' - `Exposure` - Number of days of exposure, name specified by cExposureCol.
#' 
#'  The input data has one or more rows per site. Transform_EventCount sums cCountCol for a TotalCount for each site. 
#'  For data with an optional cExposureCol, a summed exposure is caculated for each site.
#'
#' @param dfInput A data frame with one Record per person
#' @param cCountCol required. numerical or logical. Column to be counted.
#' @param cExposureCol Optional, numerical Exposure Column
#' 
#' @return data.frame with one row per site with columns SiteID, N, TotalCount with additional columns Exposure and Rate if cExposureCol is used.
#' 
#' @examples 
#' dfInput <- AE_Map_Adam( safetyData::adam_adsl, safetyData::adam_adae )
#' dfTransformed <- Transform_EventCount( dfInput, cCountCol = 'Count', cExposureCol = "Exposure" )
#' 
#'
#' @export

Transform_EventCount <- function( dfInput , cCountCol, cExposureCol=NULL ){
    stopifnot(
        "dfInput is not a data frame" = is.data.frame(dfInput),
        "cCountCol not found in input data" = cCountCol %in% names(dfInput),
        "cCount column is not numeric or logical" = is.numeric(dfInput[[cCountCol]]) | is.logical(dfInput[[cCountCol]])
    )
    if(anyNA(dfInput[[cCountCol]])) stop("NA's found in dfInput$Count")  
    if(!is.null(cExposureCol)){
      stopifnot(
        "cExposureCol is not found in input data" = cExposureCol %in% names(dfInput),
        "cExposureColumn is not numeric" = is.numeric(dfInput[[cExposureCol]])
      )
      ExposureNACount <- sum(is.na(dfInput[[cExposureCol]]))
      if(ExposureNACount>0){
        warning(paste0("Dropped ",ExposureNACount," record(s) from dfInput where cExposureColumn is NA."))
        dfInput <- dfInput %>% filter(!is.na(.data[[cExposureCol]]))
      }
    }

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