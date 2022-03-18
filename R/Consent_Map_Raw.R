#' Consent Assessment Mapping from Raw Data
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
#' @param strConsentReason default = "mainconsent", filters on CONSCAT_STD of dfConsent, if NULL no filtering is done.
#'
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count.
#'
#' @import dplyr
#'
#' @examples
#'
#' input <- Consent_Map_Raw(
#'  dfConsent = clindata::raw_consent %>% dplyr::filter(!is.na(SUBJID) & SUBJID != ""),
#'  dfRDSL = clindata::rawplus_rdsl,
#'  strConsentReason = NULL
#' )
#'
#' @export
Consent_Map_Raw <- function( dfConsent, dfRDSL, mapping = NULL, strConsentReason = "mainconsent"){

  # Set defaults for mapping if none is provided
  if(is.null(mapping)){
    mapping <- list(
      dfConsent = list(strIDCol="SUBJID", strTypeCol = "CONSCAT_STD", strStatusCol = "CONSYN", strDateCol = "CONSDAT"),
      dfRDSL = list(strIDCol="SubjectID", strSiteCol="SiteID", strRandDateCol="RandDate")
    )
  }

  # Check input data vs. mapping.
  is_consent_valid <- is_mapping_valid(
    dfConsent,
    mapping$dfConsent,
    vRequiredParams = c("strIDCol", "strTypeCol", "strStatusCol", "strDateCol"),
    vNACols = mapping$dfRDSL$strDateCol
    )

  is_rdsl_valid <- is_mapping_valid(
    dfRDSL,
    mapping$dfRDSL,
    vRequiredParams = c("strIDCol", "strSiteCol", "strRandDateCol"),
    vUniqueCols = mapping$dfRDSL$strIDCol
    )


  if(!is.null(strConsentReason)){
    stopifnot(
      "strConsentReason is not character"=is.character(strConsentReason),
      "strConsentReason has multiple values, specify only one"= length(strConsentReason)==1,
      "Errors found in dfConsent" = is_consent_valid$status,
      "Errors found in dfRDSL" = is_rdsl_valid$status
    )
  }

  dfRDSL <- dfRDSL %>%
    rename(SubjectID = mapping[["dfRDSL"]][["strIDCol"]],
           SiteID = mapping[["dfRDSL"]][["strSiteCol"]],
           RandDate = mapping[["dfRDSL"]][["strRandDate"]]) %>%
    select(.data$SubjectID, .data$SiteID, .data$RandDate)

  dfConsent <- dfConsent %>%
    rename(SubjectID = mapping[["dfConsent"]][["strIDCol"]],
           CONSCAT_STD = mapping[["dfConsent"]][["strCONScatstd"]],
           CONSYN = mapping[["dfConsent"]][["strCONSyn"]],
           CONSDAT = mapping[["dfConsent"]][["strCONSdat"]]) %>%
    select(.data$SubjectID, .data$CONSCAT_STD , .data$CONSYN , .data$CONSDAT)

  dfInput <- inner_join(dfRDSL, dfConsent, by='SubjectID')


  dfRDSLSiteIDNACount <- sum(is.na(dfRDSL$SiteID))
  missIE <- anti_join( dfConsent, dfRDSL, by="SubjectID")

  if(dfRDSLSiteIDNACount > 0){
    warning(paste0("Dropped ", dfRDSLSiteIDNACount, " record(s) from dfRDSL where SiteID is NA."))

    dfRDSL <- dfRDSL %>%
      filter(!is.na(.data$SiteID))
  }

  if(nrow(missIE) > 0){
    warning("Not all SubjectID in dfConsent found in dfRDSL")
  }

  if(!is.null(strConsentReason)){
    dfInput <- dfInput %>%
      filter(tolower(.data$CONSCAT_STD) == tolower(strConsentReason))

    stopifnot("supplied strConsentReason not found in data" = nrow(dfInput) != 0 )
  }

  dfInput <-  dfInput %>%
    mutate(flag_noconsent = .data$CONSYN == "No") %>%
    mutate(flag_missing_consent = is.na(.data$CONSDAT))%>%
    mutate(flag_missing_rand = is.na(.data$RandDate))%>%
    mutate(flag_date_compare = .data$CONSDAT >= .data$RandDate ) %>%
    mutate(any_flag = .data$flag_noconsent | .data$flag_missing_consent | .data$flag_missing_rand | .data$flag_date_compare) %>%
    mutate(Count = as.numeric(.data$any_flag, na.rm = TRUE)) %>%
    select(.data$SubjectID, .data$SiteID, .data$Count)

  return(dfInput)
}
