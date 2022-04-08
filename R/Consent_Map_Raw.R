#' Consent Assessment Mapping from Raw Data
#'
#' Convert from raw data format to needed input format for \code{\link{Consent_Assess}}
#'
#' @details
#'
#' This function uses raw Consent and Subject data to create the required input for \code{\link{Consent_Assess}}.
#'
#' @section Data Specification:
#' The following columns are required:
#' - `dfCONSENT`
#'     - `SubjectID` - Subject ID
#'     - `CONSCAT_STD` - Type of Consent_Coded value
#'     - `CONSYN` - Did the subject give consent? Yes / No.
#'     - `CONSDAT` - If yes, provide date consent signed
#' - `dfSUBJ`
#'     - `SubjectID` - Unique subject ID
#'     - `SiteID` - Site ID
#'     - `RandDate` - Randomization Date
#'
#' @param dfCONSENT consent data frame with columns: SUBJID, CONSCAT_STD , CONSYN , CONSDAT.
#' @param dfSUBJ Subject-level Raw Data required columns: SubjectID SiteID RandDate.
#' @param mapping List containing expected columns in each data set.
#' @param strConsentTypeValue default = "mainconsent", filters on CONSCAT_STD of dfCONSENT, if NULL no filtering is done.
#' @param strConsentStatusValue default = "Yes", expected Status value for valid consent.
#'
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count.
#'
#' @import dplyr
#'
#' @examples
#'
#' input <- Consent_Map_Raw(
#'    dfCONSENT = clindata::rawplus_consent,
#'    dfSUBJ = clindata::rawplus_subj
#')
#'
#' @export

Consent_Map_Raw <- function( dfCONSENT, dfSUBJ, mapping = NULL, strConsentTypeValue = "MAINCONSENT", strConsentStatusValue="Y"){

  # Set defaults for mapping if none is provided
  if(is.null(mapping)){
    mapping <- list(
      dfCONSENT = list(strIDCol = "SubjectID", strTypeCol = "CONSENT_TYPE", strValueCol = "CONSENT_VALUE", strDateCol = "CONSENT_DATE"),
      dfSUBJ = list(strIDCol = "SubjectID", strSiteCol = "SiteID", strRandDateCol = "RandDate")
    )
  }

  # Check input data vs. mapping
  is_consent_valid <- is_mapping_valid(
    df = dfCONSENT,
    mapping = mapping$dfCONSENT,
    vRequiredParams = c("strIDCol", "strTypeCol", "strValueCol", "strDateCol"),
    vNACols = c("strDateCol"),
    bQuiet=FALSE
  )

  is_subj_valid <- is_mapping_valid(
    df = dfSUBJ,
    mapping = mapping$dfSUBJ,
    vRequiredParams = c("strIDCol", "strSiteCol", "strRandDateCol"),
    vUniqueCols = "strIDCol",
    bQuiet=FALSE
  )

  stopifnot(
    "Errors found in dfCONSENT." = is_consent_valid$status,
    "Errors found in dfSUBJ." = is_subj_valid$status,
    "strConsentTypeValue is not character"= is.character(strConsentTypeValue),
    "strConsentTypeValue has multiple values, specify only one" = length(strConsentTypeValue)==1
  )

  # Standarize Column Names
  dfSUBJ_mapped <- dfSUBJ %>%
    rename(
      SubjectID = mapping[["dfSUBJ"]][["strIDCol"]],
      SiteID = mapping[["dfSUBJ"]][["strSiteCol"]],
      RandDate = mapping[["dfSUBJ"]][["strRandDateCol"]]
    ) %>%
    select(.data$SubjectID, .data$SiteID, .data$RandDate)

  dfCONSENT_mapped <- dfCONSENT %>%
    rename(
      SubjectID = mapping[["dfCONSENT"]][["strIDCol"]],
      ConsentType = mapping[["dfCONSENT"]][["strTypeCol"]],
      ConsentStatus = mapping[["dfCONSENT"]][["strValueCol"]],
      ConsentDate = mapping[["dfCONSENT"]][["strDateCol"]]
    ) %>%
    select(.data$SubjectID, .data$ConsentType , .data$ConsentStatus , .data$ConsentDate)


  if(!is.null(strConsentTypeValue)){
    dfCONSENT_mapped <- dfCONSENT_mapped %>%
      filter(.data$ConsentType == strConsentTypeValue)
    if(nrow(dfCONSENT_mapped)==0) stop("supplied strConsentTypeValue not found in data")
  }

  dfInput <- mergeSubjects(dfCONSENT_mapped, dfSUBJ_mapped)%>%
    mutate(flag_noconsent = .data$ConsentStatus != strConsentStatusValue) %>%
    mutate(flag_missing_consent = is.na(.data$ConsentDate))%>%
    mutate(flag_missing_rand = is.na(.data$RandDate))%>%
    mutate(flag_date_compare = .data$ConsentDate >= .data$RandDate ) %>%
    mutate(any_flag = .data$flag_noconsent | .data$flag_missing_consent | .data$flag_missing_rand | .data$flag_date_compare) %>%
    mutate(Count = as.numeric(.data$any_flag, na.rm = TRUE)) %>%
    select(.data$SubjectID, .data$SiteID, .data$Count)

  return(dfInput)
}
