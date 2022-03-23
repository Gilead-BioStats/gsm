#' Consent Assessment Mapping from Raw Data
#'
#' Convert from raw data format to needed input format for \code{\link{Consent_Assess}}
#'
#' @details
#'
#' This function uses raw Consent and RDSL data to create the required input for \code{\link{Consent_Assess}}.
#'
#' @section Data Specification:
#' The following columns are required:
#' - `dfConsent`
#'     - `SUBJID` - Subject ID
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
#' @param mapping List containing expected columns in each data set.
#' @param strConsentTypeValue default = "mainconsent", filters on CONSCAT_STD of dfConsent, if NULL no filtering is done.
#' @param strConsentStatusValue default = "Yes", expected Status value for valid consent.
#'
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count.
#'
#' @import dplyr
#'
#' @examples
#' library(dplyr)
#' raw_consent <- clindata::raw_ic_elig %>% 
#'    select( c("SUBJID","DSSTDAT_RAW") )%>%
#'    mutate( CONSCAT_STD = "MAINCONSENT", CONSYN="Y") %>%
#'    rename( CONSDAT = DSSTDAT_RAW ) %>%
#'    mutate( CONSDAT = as.Date(CONSDAT, format="%d %B %Y") ) %>%
#'    filter(SUBJID != "")
#'
#' input <- Consent_Map_Raw(
#'    dfConsent = raw_consent,
#'    dfRDSL = clindata::rawplus_rdsl,
#'    strConsentTypeValue = "MAINCONSENT",
#'    strConsentStatusValue="Y"
#')
#'
#' @export

Consent_Map_Raw <- function( dfConsent, dfRDSL, mapping = NULL, strConsentTypeValue = "mainconsent", strConsentStatusValue="Yes"){
  
  # Set defaults for mapping if none is provided
  if(is.null(mapping)){
    mapping <- list(
      dfConsent = list(strIDCol = "SUBJID", strConsentTypeCol = "CONSCAT_STD", strConsentStatusCol = "CONSYN", strConsentDateCol = "CONSDAT"),
      dfRDSL = list(strIDCol = "SubjectID", strSiteCol = "SiteID", strRandDateCol = "RandDate")
    )
  }
  
  # Check input data vs. mapping
  dfConsentMapping <- is_mapping_valid(
    df = dfConsent,
    mapping = mapping$dfConsent,
    vRequiredParams = c("strIDCol", "strConsentTypeCol", "strConsentStatusCol", "strConsentDateCol"),
    vNACols = c("strConsentDateCol"),
    bQuiet=FALSE
  )

  dfRDSLMapping <- is_mapping_valid(
    df = dfRDSL,
    mapping = mapping$dfRDSL,
    vRequiredParams = c("strIDCol", "strSiteCol", "strRandDateCol"),
    vUniqueCols = "strIDCol",
    bQuiet=FALSE
  )

  stopifnot(
    "Errors found in dfConsent" = dfConsentMapping$status,
    "Errors found in dfRDSL" = dfRDSLMapping$status
  )

  if(!is.null(strConsentTypeValue)){
    stopifnot(
      "strConsentTypeValue is not character"=is.character(strConsentTypeValue),
      "strConsentTypeValue has multiple values, specify only one"= length(strConsentTypeValue)==1
    )
  }

  # Standarize Column Names
  dfRDSL_mapped <- dfRDSL %>%
    rename(
      SubjectID = mapping[["dfRDSL"]][["strIDCol"]],
      SiteID = mapping[["dfRDSL"]][["strSiteCol"]],
      RandDate = mapping[["dfRDSL"]][["strRandDateCol"]]
    ) %>%
    select(.data$SubjectID, .data$SiteID, .data$RandDate)

  dfConsent_mapped <- dfConsent %>%
    rename(
      SubjectID = mapping[["dfConsent"]][["strIDCol"]],
      ConsentType = mapping[["dfConsent"]][["strConsentTypeCol"]],
      ConsentStatus = mapping[["dfConsent"]][["strConsentStatusCol"]],
      ConsentDate = mapping[["dfConsent"]][["strConsentDateCol"]]
    ) %>%
    select(.data$SubjectID, .data$ConsentType , .data$ConsentStatus , .data$ConsentDate)


  if(!is.null(strConsentTypeValue)){
    dfConsent_mapped <- dfConsent_mapped %>% filter(tolower(.data$ConsentType) == tolower(strConsentTypeValue))
    if(nrow(dfConsent_mapped)==0) stop("supplied strConsentTypeValue not found in data")
  }
  
  dfInput <- mergeSubjects(dfConsent_mapped, dfRDSL_mapped)%>%
    mutate(flag_noconsent = .data$ConsentStatus != strConsentStatusValue) %>%
    mutate(flag_missing_consent = is.na(.data$ConsentDate))%>%
    mutate(flag_missing_rand = is.na(.data$RandDate))%>%
    mutate(flag_date_compare = .data$ConsentDate >= .data$RandDate ) %>%
    mutate(any_flag = .data$flag_noconsent | .data$flag_missing_consent | .data$flag_missing_rand | .data$flag_date_compare) %>%
    mutate(Count = as.numeric(.data$any_flag, na.rm = TRUE)) %>%
    select(.data$SubjectID, .data$SiteID, .data$Count)

  return(dfInput)
}
