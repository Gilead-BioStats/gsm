#' Safety Assessment Mapping - Make Input Data
#' 
#' Convert from ADaM format to needed input format for Safety Assessment
#'
#' @param dfADSL ADaM demographics data with the following required columns:  USUBJID, SITEID, TRTEDT (end date), TRTSDT (start date)
#' @param dfADAE ADaM AE data with the following required columns: USUBJID
#'
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count, Exposure, Rate, Unit
#' 
#' @export

AE_Map_Adam <- function( dfADSL, dfADAE ){
  stopifnot(
    is.data.frame(dfADSL), 
    is.data.frame(dfADAE),
    all(c("USUBJID", "SITEID", "TRTEDT", "TRTSDT") %in% names(dfADSL)),
    "USUBJID" %in% names(dfADAE)
  )
  dfADAE <- safetyData::adam_adae
  
  dfADSL <- safetyData::adam_adsl
  
  
  dfADAE <- dfADAE %>% filter(USUBJID %in% dfADSL$USUBJID)
  
  dfADSLcount <-  dfADSL %>% 
    group_by(.data$USUBJID) %>%
    summarise( Count = as.numeric(sum(dfADAE$USUBJID %in% .data$USUBJID) ))
  
  
  dfInput <- dfADSL %>% 
    right_join(dfADSLcount, by = 'USUBJID') %>%
    rename(SubjectID = .data$USUBJID) %>%
    rename(SiteID = .data$SITEID) %>%
    mutate(Exposure = (as.numeric(.data$TRTEDT - .data$TRTSDT)+1)/7 ) %>% 
    mutate(Rate = .data$Count/.data$Exposure) %>%
    mutate(Rate = round(.data$Rate, 4) ) %>%
    mutate(Unit = 'Week') %>%
    select(.data$SubjectID,.data$SiteID, .data$Count, .data$Exposure, .data$Rate, .data$Unit)
  
  
  return(dfInput)
}