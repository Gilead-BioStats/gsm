 #' Safety Assessment Mapping - Make Input Data
#' 
#' Convert from ADaM format to needed input format for Safety Assessment
#' @details
#'  
#' This function maps ADAM ADSL and ADAE data to the required input for  \code{\link{AE_Assess}}. 
#' 
#' @section Data Pipeline:
#' 
#' The input data in (`ADSL`) Must have these required columns
#' - `USUBJID` - Unique subject ID
#' - `SITEID` - Site ID
#' - `TRTEDT`  - end date
#' - `TRTSDT`  - start date
#'
#' The input data in (`ADAE`) Must have these required columns
#' - `USUBJID` - Unique subject ID
#' 
#' @param dfADSL ADaM demographics data with the following required columns:  USUBJID, SITEID, TRTEDT (end date), TRTSDT (start date)
#' @param dfADAE ADaM AE data with the following required columns: USUBJID
#'
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count, Exposure, Rate, Unit
#'
#' @examples 
#' dfInput <- AE_Map_Adam( safetyData::adam_adsl, safetyData::adam_adae )
#'  
#' @export

AE_Map_Adam <- function( dfADSL, dfADAE ){
  stopifnot(
    is.data.frame(dfADSL), 
    is.data.frame(dfADAE),
    all(c("USUBJID", "SITEID", "TRTEDT", "TRTSDT") %in% names(dfADSL)),
    "USUBJID" %in% names(dfADAE)
  )
  
  dfInput <-  dfADSL %>% 
    rename(SubjectID = .data$USUBJID) %>%
    rename(SiteID = .data$SITEID) %>%
    mutate(Exposure = as.numeric(.data$TRTEDT - .data$TRTSDT)+1) %>% 
    mutate(Unit = 'Days') %>%
    rowwise() %>%
    mutate(Count =sum(dfADAE$USUBJID==.data$SubjectID)) %>% 
    mutate(Rate = .data$Count/.data$Exposure) %>%
    select(.data$SubjectID,.data$SiteID, .data$Count, .data$Exposure, .data$Rate, .data$Unit)

  return(dfInput)
}