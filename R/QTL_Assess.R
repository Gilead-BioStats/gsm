#' Disposition Assessment - QTL
#'
#' @param lInput `list` Returned from `Disp_Map_Raw_QTL`
#' @param strDomain `character` One of `disp` (Disposition Assessment) or `pd` (Protocol Deviation Assessment)
#'
#' @return `data.frame` Containing rows for each snapshot date.
#'
#'
#'
#' @export
QTL_Assess <- function(lInput, strDomain) {

  strDenominatorVal <- switch(strDomain, pd = "Exposure", disp = "Total")
  strOutcomeVal <- switch(strDomain, pd = "Rate", disp = "Binary")
  vThresholdVal <- switch(strDomain, pd = c(NA, 0.0043), disp = c(NA, 0.0531))
  lSnapshotDates <- lInput$SnapshotDates
  lInput$SnapshotDates <- NULL

  # transform ---------------------------------------------------------------
  lTransform <- map(lInput, ~Transform_Rate(., strNumeratorCol = "Count",
                                            strDenominatorCol = strDenominatorVal,
                                            strGroupCol = "StudyID"))

  # analyze -----------------------------------------------------------------
  lAnalyzed <- map(lTransform, ~AnalyzeQTL(., strOutcome = strOutcomeVal))


  # flag --------------------------------------------------------------------
  lFlagged <- map(lAnalyzed, ~Flag(., strColumn = "LowCI", vThreshold = vThresholdVal))


  # stack/summarize ---------------------------------------------------------
  dfSummary <- bind_rows(lFlagged) %>%
    bind_cols(lSnapshotDates)

  return(dfSummary)
}









