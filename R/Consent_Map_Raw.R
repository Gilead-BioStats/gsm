#' Consent Assessment Mapping from Raw Data- Make Input Data
#' 
#' Convert from raw data format to needed input format for \code{\link{Consent_Assess}}
#' 
#' @details
#' 
#' This function uses raw Consent and RDSL data to create the required input for \code{\link{Consent_Assess}}. 
#' 
#' @section Data Specification:
#'
#'
#' The following columns are required:
#' - `dfConsent`
#'     - `SUBJID` - Unique subject ID
#'     - `CONSCAT_STD` - Type of Consent_Coded value
#'     - `CONSYN` - Did the subject give consent? Yes / No.
#'     - `CONSDAT` - If yes, provide date consent signed     
#' - `dfRDSL`
#'     - `SubjectID` - Unique subject ID
#'     - `SiteID` - Site ID
#'     - `RandData` - Randomization Date
#'
#' @param dfConsent consent data frame with columns: SUBJID, CONSCAT_STD , CONSYN , CONSDAT.
#' @param dfRDSL Subject-level Raw Data (RDSL) required columns: SubjectID SiteID RandDate.
#' @param strConsentReason default = "mainconsent", filters on CONSCAT_STD of dfConsent, if NULL no filtering is done.
#' 
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count.
#' 
#' @import dplyr
#' @import lubridate
#' 
#' @examples
#'
#' input <- Consent_Map_Raw(dfConsent = clindata::raw_consent, dfRDSL = clindata::rawplus_rdsl, strConsentReason = NULL)
#' 
#' @export 
Consent_Map_Raw <- function( dfConsent,dfRDSL, strConsentReason = "mainconsent"){
  stopifnot(

    "dfConsent dataset not found"=is.data.frame(dfConsent),
    "dfRDSL dataset is not found"=is.data.frame(dfRDSL),
    "SUBJID, CONSCAT_STD , CONSYN , CONSDAT column not found in dfConsent"=c("SUBJID", "CONSCAT_STD" , "CONSYN" , "CONSDAT" ) %in% names(dfConsent),
    "SubjectID, SiteID and RandData column not found in dfIxrsrand"= c("SubjectID", "SiteID" , "RandDate") %in% names(dfRDSL)
  )
  
  dfConsent<- dfConsent %>%
    select(.data$SUBJID, .data$CONSCAT_STD , .data$CONSYN , .data$CONSDAT)%>%
    rename(SubjectID = .data$SUBJID)
  
 
  
  
  dfInput <- dfRDSL %>%
    select(.data$SubjectID, .data$SiteID, .data$RandDate)%>%
    left_join(dfConsent, by='SubjectID')
  
    if(!is.null(strConsentReason)){
      dfInput <- dfInput %>% filter(to.lower(.data$CONSCAT_STD) == to.lower(strConsentReason))
    }
  
  dfInput <-  dfInput %>%
    mutate(flag_noconsent=.data$CONSYN=="No") %>%
    mutate(flag_missing_consent = is.na(.data$CONSDAT))%>%
    mutate(flag_missing_rand = is.na(.data$RandDate))%>%
    mutate(flag_date_compare = .data$CONSDAT >= .data$RandDate ) %>%
    mutate(any_flag=.data$flag_noconsent | .data$flag_missing_consent | .data$flag_missing_rand | .data$flag_date_compare) %>%
    mutate(Count = as.numeric(.data$any_flag)) %>%
    select(.data$SubjectID, .data$SiteID, .data$Count) 

  return(dfInput)
}