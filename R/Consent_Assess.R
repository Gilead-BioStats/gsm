#' Consent Assessment
#'
#' @details
#'
#' The Consent Assessment uses the standard GSM data pipeline (TODO add link to data vignette) to flag sites with participants who started study activities before consent was finalized. More details regarding the data pipeline and statistical methods are described below.
#'
#' @section Data Specification:
#'
#' The input data (`dfInput`) for Consent Assessment is typically created using \code{\link{Consent_Map_Raw}} and should be one record per person with columns for:
#' - `SubjectID` - Unique subject ID
#' - `SiteID` - Site ID
#' - `Count` - Number of findings of errors/outliers.
#'
#' The Assessment
#' - \code{\link{Transform_EventCount}} creates `dfTransformed`.
#' - \code{\link{Flag}} creates `dfFlagged`.
#' - \code{\link{Summarize}} creates `dfSummary`.
#'
#' @section Statistical Assumptions:
#'
#' This Assessment finds any sites where one or more subjects meets any of the following criteria: No Consent, Missing Consent, Missing Randomization Date, or
#' Consent date later in time than the Randomization Date. 'N' in the summary represents the number of subjects in a study that meet one or more criteria. Sites
#' With N greater than user specified `nThreshold` will be flagged.
#'
#' @param dfInput input data with one record per person and the following required columns: SubjectID, SiteID, Count.
#' @param nThreshold Any sites where 'N' is greater than nThreshold will be flagged. Default value is 0.5, which flags any site with one or more subjects meeting any of the criteria.
#' @param lTags named list of tags describing the assessment. `lTags` is returned as part of the assessment (`lAssess$lTags`) and each tag is added as columns in `lassess$dfSummary`. Default is `list(Assessment="Consent")`
#' @param bChart should visualization be created? TRUE (default) or FALSE.
#'
#' @examples
#' dfInput <- Consent_Map_Raw()
#' consent <- Consent_Assess(dfInput)
#'
#' @import dplyr
#'
#' @return A list containing all data and metadata in the standard data pipeline (`dfInput`, `dfTransformed`, `dfAnalyzed`, `dfFlagged`, `dfSummary`, `strFunctionName`, `lParams` and `lTags`) is returned.
#'
#' @export

Consent_Assess <- function(
    dfInput,
    nThreshold=0.5,
    lTags=list(Assessment="Consent"),
    bChart=TRUE,
    bReturnChecks=FALSE,
    bQuiet=TRUE
){

  stopifnot(
    "dfInput is not a data.frame" = is.data.frame(dfInput),
    "One or more of these columns: SubjectID, SiteID,and Count not found in dfInput"=all(c("SubjectID","SiteID", "Count") %in% names(dfInput)),
    "nThreshold must be numeric" = is.numeric(nThreshold),
    "nThreshold must be length 1" = length(nThreshold) ==1
  )

  if(!is.null(lTags)){
      stopifnot(
          "lTags is not named"=(!is.null(names(lTags))),
          "lTags has unnamed elements"=all(names(lTags)!=""),
          "lTags cannot contain elements named: 'SiteID', 'N', 'Score', or 'Flag'" = !names(lTags) %in% c("SiteID", "N", "Score", "Flag")
      )
  }

  lAssess <- list(
    strFunctionName = deparse(sys.call()[1]),
    lParams = lapply(as.list(match.call()[-1]), function(x) as.character(x)),
    lTags = lTags,
    dfInput = dfInput
  )


  if(!bQuiet) cli::cli_h2("Checking Input Data for {.fn Consent_Assess}")
  checks <- CheckInputs(
    context = "Consent_Assess",
    dfs = list(dfInput = lAssess$dfInput),
    bQuiet = bQuiet
  )

  if(checks$status){
    if(!bQuiet) cli::cli_h2("Initializing {.fn Consent_Assess}")
    if(!bQuiet) cli::cli_text("Input data has {nrow(lAssess$dfInput)} rows.")
    lAssess$dfTransformed <- gsm::Transform_EventCount( lAssess$dfInput, strCountCol = 'Count'  )
    if(!bQuiet) cli::cli_alert_success("{.fn Transform_EventCount} returned output with {nrow(lAssess$dfTransformed)} rows.")

    lAssess$dfAnalyzed <-lAssess$dfTransformed %>% mutate(Estimate = .data$TotalCount)

    lAssess$dfFlagged <- gsm::Flag( lAssess$dfAnalyzed ,vThreshold = c(NA,nThreshold), strColumn = "Estimate" )
    if(!bQuiet) cli::cli_alert_success("{.fn Flag} returned output with {nrow(lAssess$dfFlagged)} rows.")

    lAssess$dfSummary <- gsm::Summarize( lAssess$dfFlagged, strScoreCol="TotalCount", lTags)
    if(!bQuiet) cli::cli_alert_success("{.fn Summarize} returned output with {nrow(lAssess$dfSummary)} rows.")

    if (bChart) {
      lAssess$chart <- Visualize_Count(lAssess$dfAnalyzed)
      if(!bQuiet) cli::cli_alert_success("{.fn Visualize_Count} created a chart.")
    }
  } else {
      if(!bQuiet) cli::cli_alert_warning("{.fn AE_Assess} not run because of failed check.")
  }

  if(bReturnChecks) lAssess$lChecks <- checks
  return(lAssess)

}

