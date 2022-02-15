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
#'     - `INVID` - Current Investigator identifier
#'     - `CONSCAT_STD` - Type of Consent_Coded value
#'     - `CONSYN` - Did the subject give consent? Yes / No.
#'     - `CONSDAT` - If yes, provide date consent signed     
#' - `dfIxrsrand`
#'     - `SUBJID` - Unique subject ID
#'     - `RGMNDTN` - RGMNDTN or RGMNTDC is required. Randomization Date, site local time
#'     - `RGMNDTC` - RGMNDTC or RGMNTDN is required. Randomization Date, site local time
#'
#'
#' @param dfConsent consent data frame with columns: SUBJID,  INVID,  CONSCAT_STD , CONSYN , CONSDAT.
#' @param dfIxrsrand Ixrsand data frame with required columns: SUBJID, RGMNDTN or RGMNDTC.
#' 
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count.
#' 
#' @examples
#' 
#'dfConsent <- tibble::tribble(~SUBJID,  ~INVID,  ~CONSCAT_STD , ~CONSYN , ~CONSDAT,
#'                             1,       1,  "MAINCONSENT",    "Yes", "2014-12-25",
#'                             2,       2,  "MAINCONSENT",    "Yes", "2014-12-25",
#'                             3,       2,  "MAINCONSENT",     "No", "2014-12-25",
#'                             4,       2,   "NonCONSENT",    "Yes", "2014-12-25",
#'                             5,       3,  "MAINCONSENT",    "Yes", "2014-12-25"  )
#'
#'dfIxrsrand <- tibble::tribble(~SUBJID, ~RGMNDTN,
#'                              1,   "2013-12-25",
#'                              2,   "2015-12-25",
#'                              3,   "2013-12-25",
#'                              4,   "2013-12-25",
#'                              5,   "2013-12-25")
#'
#'
#'dfInput <-  Consent_Map_Raw(dfConsent = dfConsent, dfIxrsrand = dfIxrsrand)
#'  
#' 
#' @import dplyr
#' @import lubridate
#' 
#' @export 
Consent_Map_Raw <- function( 
  dfConsent = NULL,
  dfIxrsrand = NULL
){


  if(is.null(dfConsent)) stop("Consent dataset not found")
  if(is.null(dfIxrsrand)) stop("Ixrsrand dataset not found")
  
  if(is.null(as.data.frame(dfIxrsrand)$RGMNDTN) & !(is.null(as.data.frame(dfIxrsrand)$RGMNDC))){
    dfIxrsrand = dfIxrsrand %>% mutate(RGMNDTN = as.Date(.data$RGMNDTC,format="%d%b%y" ))
  }
 
  stopifnot(
    "dfConsent dataset not found"=is.data.frame(dfConsent),
    "dfIxrsrand dataset is not found"=is.data.frame(dfIxrsrand),
    "SUBJID,  INVID,  CONSCAT_STD , CONSYN , CONSDAT column not found in dfConsent"=c("SUBJID", "INVID",  "CONSCAT_STD" , "CONSYN" , "CONSDAT" ) %in% names(dfConsent),
    "SUBJID column not found in dfIxrsrand"= ("SUBJID"  %in% names(dfIxrsrand)),
    "RGMNDTN or RGMNDTC column not found in dfIxrsrand"=  "RGMNDTN" %in% names(dfIxrsrand)
  )
  
  
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