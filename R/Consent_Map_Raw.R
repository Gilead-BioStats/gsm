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
#'     - `RandDate` - Randomization Date
#'
#' @param dfConsent consent data frame with columns: SUBJID, CONSCAT_STD , CONSYN , CONSDAT.
#' @param dfRDSL Subject-level Raw Data (RDSL) required columns: SubjectID SiteID RandDate.
#' @param strConsentReason default = "mainconsent", filters on CONSCAT_STD of dfConsent, if NULL no filtering is done.
#' 
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count.
#' 
#' @import dplyr
#' 
#' @examples
#'
#' input <- Consent_Map_Raw(
#'  dfConsent = clindata::raw_consent, 
#'  dfRDSL = clindata::rawplus_rdsl, 
#'  strConsentReason = NULL
#' )
#' 
#' @export 
Consent_Map_Raw <- function( dfConsent,dfRDSL, strConsentReason = "mainconsent"){
  stopifnot(

    "dfConsent dataset not found"=is.data.frame(dfConsent),
    "dfRDSL dataset is not found"=is.data.frame(dfRDSL),
    "SUBJID, CONSCAT_STD , CONSYN , CONSDAT column not found in dfConsent"=c("SUBJID", "CONSCAT_STD" , "CONSYN" , "CONSDAT" ) %in% names(dfConsent),
    "SubjectID, SiteID and RandDate column not found in dfRDSL"= c("SubjectID", "SiteID" , "RandDate") %in% names(dfRDSL),
    "NAs found in SUBJID column of dfConsent" = all(!is.na(dfConsent$SUBJID)),
    "NAs found in SubjectID column of dfRDSL" = all(!is.na(dfRDSL$SubjectID))
  )
  if(!is.null(strConsentReason)){
    stopifnot(
      "strConsentReason is not character"=is.character(strConsentReason),
      "strConsentReason has multiple values, specify only one"= length(strConsentReason)==1
    )
  }

  
  dfRDSLSiteIDNACount <- sum(is.na(dfRDSL[['SiteID']]))
  if(dfRDSLSiteIDNACount>0){
    warning(paste0("Dropped ",dfRDSLSiteIDNACount," record(s) from dfRDSL where SiteID is NA."))
    dfRDSL <- dfRDSL %>% filter(!is.na(.data[['SiteID']]))
  }
  
  
  dfConsent<- dfConsent %>%
    select(.data$SUBJID, .data$CONSCAT_STD , .data$CONSYN , .data$CONSDAT)%>%
    rename(SubjectID = .data$SUBJID)
  
  missIE <- anti_join( dfConsent, dfRDSL, by="SubjectID")
  if( nrow(missIE) > 0 ) warning("Not all SubjectID in dfConsent found in dfRDSL")
  
  dfInput <- dfRDSL %>%
    select(.data$SubjectID, .data$SiteID, .data$RandDate)%>%
    inner_join(dfConsent, by='SubjectID')
  
    if(!is.null(strConsentReason)){
      dfInput <- dfInput %>% filter(tolower(.data$CONSCAT_STD) == tolower(strConsentReason))
      stopifnot("supplied strConsentReason not found in data" = nrow(dfInput) != 0 ) 
    }
  
  dfInput <-  dfInput %>%
    mutate(flag_noconsent=.data$CONSYN=="No") %>%
    mutate(flag_missing_consent = is.na(.data$CONSDAT))%>%
    mutate(flag_missing_rand = is.na(.data$RandDate))%>%
    mutate(flag_date_compare = .data$CONSDAT >= .data$RandDate ) %>%
    mutate(any_flag=.data$flag_noconsent | .data$flag_missing_consent | .data$flag_missing_rand | .data$flag_date_compare) %>%
    mutate(Count = as.numeric(.data$any_flag, na.rm = TRUE)) %>%
    select(.data$SubjectID, .data$SiteID, .data$Count) 

  return(dfInput)
}