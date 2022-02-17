#' Consent Assessment Mapping from Raw Data- Make Input Data
#' 
#' Convert from raw data format to needed input format for \code{\link{Consent_Assess}}
#' 
#' @details
#' 
#' This function uses raw Consent and Ixrsand data to create the required input for \code{\link{Consent_Assess}}. 
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
#' @param dfRDSL Subject-level Raw Data (RDSL) required columns: SubjectID SiteID RandDate
#' 
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count.
#' 
#' @import dplyr
#' @import lubridate
#' 
#' @export 
Consent_Map_Raw <- function( 
  dfConsent = NULL,
  dfRDSL = NULL
){

  if(is.null(dfConsent)) stop("Consent dataset not found")
  if(is.null(dfRDSL)) stop("Ixrsrand dataset not found")

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
    left_join(dfConsent, by='SubjectID') %>%
    filter(.data$CONSCAT_STD=="MAINCONSENT")%>%
    mutate(flag_noconsent=.data$CONSYN=="No") %>%
    mutate(flag_missing_consent = is.na(.data$CONSDAT))%>%
    mutate(flag_missing_rand = is.na(.data$RandDate))%>%
    mutate(flag_date_compare = .data$CONSDAT >= .data$RandDate ) %>%
    mutate(any_flag=.data$flag_noconsent | .data$flag_missing_consent | .data$flag_missing_rand | .data$flag_date_compare) %>%
    rename(Count =  .data$any_flag) %>%
    select(.data$SubjectID, .data$SiteID, .data$Count) 

  return(dfInput)
}