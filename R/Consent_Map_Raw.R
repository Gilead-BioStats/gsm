#' Consent Assessment Mapping from Raw Data- Make Input Data
#' 
#' Convert from raw data format to needed input format for Consent Assessment
#'
#' @param dfConsent consent data frame
#' @param dfIxrsrand Ixrsand data frame
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
 
  stopifnot(
    "dfConsent dataset not found"=is.data.frame(dfConsent),
    "dfIxrsrand dataset is not found"=is.data.frame(dfIxrsrand),
    "SUBJID,  INVID,  CONSCAT_STD , CONSYN , CONSDAT column not found in dfConsent"=c("SUBJID", "INVID",  "CONSCAT_STD" , "CONSYN" , "CONSDAT" ) %in% names(dfConsent),
    "SUBJID column not found in dfIxrsrand"= ("SUBJID"  %in% names(dfIxrsrand)),
    "RGMNDTN or RGMNDTC column not found in dfIxrsrand"=  (("RGMNDTN" %in% names(dfIxrsrand)) | ("RGMNDTC"  %in% names(dfIxrsrand)))
  )
  
  if(is.null(dfIxrsrand$RGMNDTN)){
    dfIxrsrand = dfIxrsrand %>% mutate(RGMNDTN = as.Date(.data$RGMNDTC,format="%d%b%y" ))
  }
  
  
   
  # Merge randomization date and consent date
  rand <- dfIxrsrand %>% 
    filter(.data$SUBJID !="")%>%
    select(.data$SUBJID, .data$RGMNDTN)
  


  dfInput <- dfConsent %>%
    filter(.data$SUBJID !="")%>%
    filter(.data$CONSCAT_STD=="MAINCONSENT")%>%
    left_join(rand, by = 'SUBJID') %>% 
    mutate(SiteID=.data$INVID)%>%
    mutate(flag_noconsent=.data$CONSYN=="No") %>%
    mutate(flag_missing_consent = is.na(.data$CONSDAT))%>%
    mutate(flag_missing_rand = is.na(.data$RGMNDTN))%>%
    mutate(flag_date_compare = .data$CONSDAT >= .data$RGMNDTN ) %>%
    mutate(any_flag=.data$flag_noconsent | .data$flag_missing_consent | .data$flag_missing_rand | .data$flag_date_compare) %>%
    rename(SubjectID = .data$SUBJID) %>% 
    rename(Count =  .data$any_flag) %>%
    select(.data$SubjectID, .data$SiteID, .data$Count) 

  return(dfInput)
}