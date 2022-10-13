#' Disposition Assessment - QTL
#'
#' @param lInput `list` Returned from `Disp_Map_Raw_QTL`
#' @param lSnapshotDates Returned from `Disp_Map_Raw_QTL`
#'
#' @return
#' @export
QTL_Assess <- function(lInput, lSnapshotDates, strDomain) {

  strDenominatorVal <- switch(strDomain, pd = "Exposure", disp = "Total")
  strOutcomeVal <- switch(strDomain, pd = "Rate", disp = "Binary")
  vThresholdVal <- switch(strDomain, pd = c(NA, 0.0043), disp = c(NA, 0.0531))

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









