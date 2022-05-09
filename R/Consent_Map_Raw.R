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
#' @param dfs list of data frames including:
#'  - `dfCONSENT` consent data frame with columns: SUBJID, CONSCAT_STD , CONSYN , CONSDAT.
#'  - `dfSUBJ` Subject-level Raw Data required columns: SubjectID SiteID RandDate.
#' @param lMapping List containing expected columns in each data set.
#' @param bReturnChecks Should input checks using `is_mapping_valid` be returned? Default is FALSE.
#' @param bQuiet Default is TRUE, which means warning messages are suppressed. Set to FALSE to see warning messages.
#'
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count.
#'
#' @examples
#'
#' dfInput <- Consent_Map_Raw() # Run with defaults
#'
#' # Run with error checking and message log
#' dfInput <- Consent_Map_Raw(bReturnChecks=TRUE, bQuiet=FALSE)
#'
#' @export

Consent_Map_Raw <- function(
    dfs=list(
      dfCONSENT=clindata::rawplus_consent,
      dfSUBJ=clindata::rawplus_subj
    ),
    lMapping = clindata::mapping_rawplus,
    bReturnChecks = FALSE,
    bQuiet = TRUE
){

  checks <- CheckInputs(
    context = "Consent_Map_Raw",
    dfs = dfs,
    bQuiet = bQuiet,
    mapping = lMapping
  )


  if(checks$status){
    if(!bQuiet) cli::cli_h2("Initializing {.fn Consent_Map_Raw}")

    # Standarize Column Names
    dfSUBJ_mapped <- dfs$dfSUBJ %>%
      dplyr::select(
        SubjectID = lMapping[["dfSUBJ"]][["strIDCol"]],
        SiteID = lMapping[["dfSUBJ"]][["strSiteCol"]],
        RandDate = lMapping[["dfSUBJ"]][["strRandDateCol"]]
      )

    dfCONSENT_mapped <- dfs$dfCONSENT %>%
      dplyr::select(
        SubjectID = lMapping[["dfCONSENT"]][["strIDCol"]],
        ConsentType = lMapping[["dfCONSENT"]][["strTypeCol"]],
        ConsentStatus = lMapping[["dfCONSENT"]][["strValueCol"]],
        ConsentDate = lMapping[["dfCONSENT"]][["strDateCol"]]
      )

    if(!is.null(lMapping$dfCONSENT$strConsentTypeValue)){
      dfCONSENT_mapped <- dfCONSENT_mapped %>%
        dplyr::filter(.data$ConsentType == lMapping$dfCONSENT$strConsentTypeValue)
      if(nrow(dfCONSENT_mapped)==0) stop("supplied strConsentTypeValue not found in data")
    }

    dfInput <- MergeSubjects(dfCONSENT_mapped, dfSUBJ_mapped, bQuiet=bQuiet)%>%
      dplyr::mutate(flag_noconsent = .data$ConsentStatus != lMapping$dfCONSENT$strConsentStatusValue) %>%
      dplyr::mutate(flag_missing_consent = is.na(.data$ConsentDate))%>%
      dplyr::mutate(flag_missing_rand = is.na(.data$RandDate))%>%
      dplyr::mutate(flag_date_compare = .data$ConsentDate >= .data$RandDate ) %>%
      dplyr::mutate(any_flag = .data$flag_noconsent | .data$flag_missing_consent | .data$flag_missing_rand | .data$flag_date_compare) %>%
      dplyr::mutate(Count = as.numeric(.data$any_flag, na.rm = TRUE)) %>%
      dplyr::select(.data$SubjectID, .data$SiteID, .data$Count)

    if(!bQuiet) cli::cli_alert_success("{.fn Consent_Map_Raw} returned output with {nrow(dfInput)} rows.")
  } else {
    if(!bQuiet) cli::cli_alert_warning("{.fn Consent_Map_Raw} not run because of failed check.")
    dfInput <- NULL
  }


  if(bReturnChecks){
    return(list(dfInput=dfInput, lChecks=checks))
  }else{
    return(dfInput)
  }
}
