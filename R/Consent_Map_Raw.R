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
#' @param bQuiet Default is TRUE, which means warning messages are suppressed. Set to FALSE to see warning messages.
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

Consent_Map_Raw <- function(
    dfs=list(
      dfCONSENT=clindata::rawplus_consent,
      dfSUBJ=clindata::rawplus_subj
    ),
    #mapping = clindata::rawplus_mapping, #TODO export rawplus_mapping in clindata
    mapping = NULL,
    bCheckInputs = FALSE,
    bQuiet = TRUE
){

  if(is.null(mapping)) mapping <- yaml::read_yaml(system.file('mapping','rawplus.yaml', package = 'clindata')) # TODO remove

  # update in clindata
  mapping$dfCONSENT$strConsentTypeValue <- "MAINCONSENT"
  mapping$dfCONSENT$strConsentStatusValue <- "Y"

  if(bCheckInputs){
    if(!bQuiet) cli::cli_h2("Checking Input Data for {.fn Consent_Map_Raw}")
    checks <- CheckInputs(dfs = dfs, bQuiet = bQuiet, mapping = mapping, step = "mapping", yaml = "Consent_Map_Raw.yaml")
    checks$status <- all(checks %>% map_lgl(~.x$status))
    run_mapping <- checks$status
  } else {
    run_mapping <- TRUE
  }

  # Standarize Column Names
  dfSUBJ_mapped <- dfs$dfSUBJ %>%
    select(
      SubjectID = mapping[["dfSUBJ"]][["strIDCol"]],
      SiteID = mapping[["dfSUBJ"]][["strSiteCol"]],
      RandDate = mapping[["dfSUBJ"]][["strRandDateCol"]]
    )

  dfCONSENT_mapped <- dfs$dfCONSENT %>%
    select(
      SubjectID = mapping[["dfCONSENT"]][["strIDCol"]],
      ConsentType = mapping[["dfCONSENT"]][["strTypeCol"]],
      ConsentStatus = mapping[["dfCONSENT"]][["strValueCol"]],
      ConsentDate = mapping[["dfCONSENT"]][["strDateCol"]]
    )

  if(!is.null(mapping$dfCONSENT$strConsentTypeValue)){
    dfCONSENT_mapped <- dfCONSENT_mapped %>%
      filter(.data$ConsentType == mapping$dfCONSENT$strConsentTypeValue)
    if(nrow(dfCONSENT_mapped)==0) stop("supplied strConsentTypeValue not found in data")
  }

  dfInput <- MergeSubjects(dfCONSENT_mapped, dfSUBJ_mapped, bQuiet=bQuiet)%>%
    mutate(flag_noconsent = .data$ConsentStatus != mapping$dfCONSENT$strConsentStatusValue) %>%
    mutate(flag_missing_consent = is.na(.data$ConsentDate))%>%
    mutate(flag_missing_rand = is.na(.data$RandDate))%>%
    mutate(flag_date_compare = .data$ConsentDate >= .data$RandDate ) %>%
    mutate(any_flag = .data$flag_noconsent | .data$flag_missing_consent | .data$flag_missing_rand | .data$flag_date_compare) %>%
    mutate(Count = as.numeric(.data$any_flag, na.rm = TRUE)) %>%
    select(.data$SubjectID, .data$SiteID, .data$Count)

  if(bCheckInputs){
    return(list(dfInput=dfInput, lChecks=checks))
  }else{
    return(dfInput)
  }
}
