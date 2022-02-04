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
  #if( ! all(c("SUBJID", "INVID", "IECAT", "IETESTCD","IETEST", "IEORRES") %in% names(dfIe)) ) stop("SUBJID, IECAT, IETEST, IETESTCD, IEORRES columns are required in ie dataset" )
  
  # Merge randomization date and consent date
  rand <- dfIxrsrand %>% 
    filter(.data$SUBJID !="")%>%
    select(.data$SUBJID, .data$RGMNDTN)

  dfInput <- dfConsent %>%
    filter(.data$SUBJID !="")%>%
    filter(.data$CONSCAT_STD=="MAINCONSENT")%>%
    left_join(rand) %>% 
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