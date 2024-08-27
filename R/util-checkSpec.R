#' Check if the data and spec are compatible
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Check if the data and spec are compatible by comparing the data.frames and
#' columns in the spec with the data.
#'
#' @param lData A list of data.frames.
#' @param lSpec A list specifying the expected structure of the data.
#'
#' @return This function does not return any value. It either prints a message indicating
#' that all data.frames and columns in the spec are present in the data, or throws an error
#' if any data.frame or column is missing.
#'
#' @examples
#' lData <- list(reporting_groups = gsm::reportingGroups, reporting_results = gsm::reportingResults)
#' lSpec <- list(
#'   reporting_groups = list(
#'     GroupID = list(required = TRUE),
#'     GroupLevel = list(required = TRUE),
#'     Param = list(required = TRUE),
#'     Value = list(required = TRUE)
#'   ),
#'   reporting_results = list(
#'     GroupID = list(required = TRUE),
#'     GroupLevel = list(required = TRUE),
#'     Numerator = list(required = TRUE),
#'     Denominator = list(required = TRUE)
#'   )
#' )
#' CheckSpec(lData, lSpec) # Prints message that everything is found
#'
#' lSpec$reporting_groups$NotACol <- list(required = TRUE)
#' CheckSpec(lData, lSpec) # Throws error that NotACol is missing
#'
#' @export
#'
CheckSpec <- function(lData, lSpec) {
  # Check that all data.frames in the spec are present in the data
  lSpecDataFrames <- names(lSpec)
  lDataFrames <- names(lData)
  if (!all(lSpecDataFrames %in% lDataFrames)) {
    MissingSpecDataFrames <- lSpecDataFrames[!lSpecDataFrames %in% lDataFrames]
    cli::cli_abort(c(
      "{.arg lData} must contain all data.frames in {.arg lSpec}.",
      i = "Missing data.frames: {MissingSpecDataFrames}"
    ))
  } else {
    cli::cli_alert("All {length(lSpecDataFrames)} data.frame(s) in the spec are present in the data: {lSpecDataFrames}")
  }

  # Check that all required columns in the spec are present in the data
  allCols <- c()
  missingCols <- c()
  for (strDataFrame in lSpecDataFrames) {
    lSpecColumns <- which(sapply(lSpec[[strDataFrame]], function(x) x$required)) %>% names
    lDataColumns <- names(lData[[strDataFrame]])
    allCols <- c(allCols, paste(strDataFrame, lSpecColumns, sep = "$"))

    thisMissingCols <- lSpecColumns[!lSpecColumns %in% lDataColumns]
    if (length(thisMissingCols) > 0) {
      missingCols <- c(missingCols, paste(strDataFrame, thisMissingCols, sep = "$"))
    }
  }
  if (length(missingCols) > 0) {
    cli::cli_alert_danger("Not all columns in the spec are present in the data, missing columns are: {missingCols}")
  } else {
    cli::cli_alert("All {length(allCols)} columns in the spec are present in the data: {allCols}")
  }
}
