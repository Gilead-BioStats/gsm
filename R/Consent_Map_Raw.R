#' Consent Assessment Mapping from Raw Data- Make Input Data
#' 
#' Convert from raw data format to needed input format for Consent Assessment
#'
#' @param strPath path to the raw datasets
#' @param dfSubid directly input a subid dataset with columns SUBJID INVID
#' @param dfIe directly input a ie dataset with columns SUBJID IECAT IETEST IEORRES
#' 
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Total, Valid, Invalid, Missing, Details
#' 
#' @import dplyr
#' @import lubridate
#' 
#' @export 
Consent_Map_Raw <- function( 
  dfConsent = NULL,
  dfIxrsrand = NULL
){

  ### Requires raw ie dataset
  if(is.null(dfConsent)) stop("Consent dataset not found")
  if(is.null(dfIxrsrand)) stop("Ixrsrand dataset not found")
  #if( ! all(c("SUBJID", "INVID", "IECAT", "IETESTCD","IETEST", "IEORRES") %in% names(dfIe)) ) stop("SUBJID, IECAT, IETEST, IETESTCD, IEORRES columns are required in ie dataset" )
  
  # Merge randomization date and consent date
  rand <- dfIxrsrand %>% 
    filter(SUBJID !="")%>%
    select(SUBJID, RGMNDTN)

  dfInput <- dfConsent %>%
    filter(SUBJID !="")%>%
    filter(CONSCAT_STD=="MAINCONSENT")%>%
    left_join(rand) %>% 
    mutate(SiteID=INVID)%>%
    mutate(flag_noconsent=CONSYN=="No") %>%
    mutate(flag_missing_consent = is.na(CONSDAT))%>%
    mutate(flag_missing_rand = is.na(RGMNDTN))%>%
    mutate(flag_date_compare = CONSDAT >= RGMNDTN ) %>%
    mutate(any_flag=flag_noconsent | flag_missing_consent | flag_missing_rand | flag_date_compare)

  return(dfInput)
}