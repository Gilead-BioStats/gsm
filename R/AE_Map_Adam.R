#' AE Assessment - ADaM Mapping
#'
#' Convert from ADaM format to input format for Safety Assessment.
#'
#' @details
#'
#' This function maps from ADaM ADSL and ADAE data to the required input for \code{\link{AE_Assess}}.
#'
#' @section Data Specification:
#'
#' This function creates an input dataset for the Adverse Event Assessment (\code{\link{AE_Assess}}) by adding Adverse Event Counts (from `dfADAE`) to basic subject-level data (from `dfADSL`).
#'
#' The following columns are required:
#' - `dfADSL`
#'   - `USUBJID` - Unique subject ID
#'   - `SITEID` - Site ID
#'   - `TRTEDT` - Treatment End date
#'   - `TRTSDT` - Treatment Start date
#' - `dfADAE`
#'    - `USUBJID` - Unique subject ID
#'
#' Note that the function can generate data summaries for specific types of AEs by passing filtered ADAE data to dfADAE.
#'
#' @param dfADSL ADaM demographics data with the following required columns:  USUBJID, SITEID, TRTEDT (end date), TRTSDT (start date)
#' @param dfADAE ADaM AE data with the following required columns: USUBJID
#' @param mapping List containing expected columns in each data set. By default, mapping for dfAE is: `strIDCol` = "SUBJID". By default, mapping for dfRDSL is: `strIDCol` = "SubjectID", `strSiteCol` = "SiteID", and `strExposureCol` = "TimeOnTreatment". TODO: add more descriptive info or reference to mapping.
#' @param bQuiet Default is TRUE, which means warning messages are suppressed. Set to FALSE to see warning messages.
#'
#' @return Data frame with one record per person data frame with columns: SubjectID, SiteID, Count (Number of Adverse Events), Exposure (Time on Treatment in Days), Rate (AEs/Day)
#'
#' @examples
#' dfInput <- AE_Map_Adam( safetyData::adam_adsl, safetyData::adam_adae )
#'
#' @import dplyr
#'
#' @export

AE_Map_Adam <- function(
    dfs=list(
      dfADSL = safetyData::adam_adsl,
      dfADAE = safetyData::adam_adae),
    lMapping = NULL,
    bReturnChecks = FALSE,
    bQuiet = TRUE
){

  if(is.null(lMapping)) lMapping <- yaml::read_yaml(system.file('mapping','rawplus.yaml', package = 'clindata')) # TODO remove
  lMapping$dfADSL <- list(strIDCol="USUBJID", strSiteCol = "SITEID", strStartCol = "TRTSDT", strEndCol = "TRTEDT")
  lMapping$dfADAE <- list(strIDCol="USUBJID")

  if(!bQuiet) cli::cli_h2("Checking Input Data for {.fn AE_Map_Adam}")
  checks <- CheckInputs(dfs = dfs, bQuiet = bQuiet, mapping = lMapping, step = "mapping", yaml = "AE_Map_Adam.yaml")
  checks$status <- all(checks %>% map_lgl(~.x$status))

  if(checks$status) {
    if(!bQuiet) cli::cli_h2("Initializing {.fn AE_Map_Adam}")

    dfInput <-  dfs$dfADSL %>%
      rename(SubjectID = .data$USUBJID) %>%
      rename(SiteID = .data$SITEID) %>%
      mutate(Exposure = as.numeric(.data$TRTEDT - .data$TRTSDT)+1) %>%
      rowwise() %>%
      mutate(Count =sum(dfs$dfADAE$USUBJID==.data$SubjectID)) %>%
      mutate(Rate = .data$Count/.data$Exposure) %>%
      select(.data$SubjectID,.data$SiteID, .data$Count, .data$Exposure, .data$Rate) %>%
      ungroup()

    if(!bQuiet) cli::cli_alert_success("{.fn AE_Map_Adam} returned output with {nrow(dfInput)} rows.")
  } else {
    if(!bQuiet) cli::cli_alert_warning("{.fn AE_Map_Adam} not run because of failed check.")
    dfInput <- NULL
  }

  if(bReturnChecks){
    return(list(df=dfInput, lChecks=checks))
  }else{
    return(dfInput)
  }
}
