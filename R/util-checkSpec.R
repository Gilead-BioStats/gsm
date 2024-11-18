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
#' lData <- list(reporting_groups = gsm::reportingBounds, reporting_results = gsm::reportingResults)
#' lSpec <- list(
#'   reporting_bounds = list(
#'     Threshold = list(type = numeric),
#'     Numerator = list(type = numeric),
#'     Denominator = list(type = numeric),
#'     Metirc = list(type = numeric)
#'   ),
#'   reporting_results = list(
#'     GroupID = list(type = character),
#'     GroupLevel = list(type = character),
#'     Numerator = list(type = numeric),
#'     Denominator = list(type = numeric)
#'   )
#' )
#' CheckSpec(lData, lSpec) # Prints message that everything is found
#'
#' lSpec$reporting_groups$NotACol <- list(type = character)
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
  # remove all lSpec entries where we are requesting `_all` columns, and no other columns are included in the df's spec
  lSpecDataFrames <- which(sapply(lSpec, function(x) (names(x)[1] != "_all") | (length(names(x)) > 1))) %>% names()
  for (strDataFrame in lSpecDataFrames) {
    chrDataFrameColnames <- colnames(lData[[strDataFrame]])
    # check classes in data
    wrongType <- purrr::reduce2(
      lSpec[[strDataFrame]],
      names(lSpec[[strDataFrame]]),
      function(so_far, x, idx) {
        if (!is.null(x$type) && idx %in% chrDataFrameColnames) {
          # check if data is the expected mode
          res <- all(x$type == class(lData[[strDataFrame]][[idx]]))
          if (!res) {
            so_far <- c(so_far, idx)
          }
          return(so_far)
        }
      },
      .init = character()
    )

    if (length(wrongType)) {
      cli::cli_alert_danger("Not all columns of {strDataFrame} in the spec are in the expected format, improperly formatted columns are: {wrongType}")
    } else {
      cli::cli_alert("All specified columns in {strDataFrame} are in the expected format")
    }
    # check that required exist in data, if _all required is not specified
    if (!isTRUE(lSpec[[strDataFrame]]$`_all`$required)) {
      lSpecColumns <- names(lSpec[[strDataFrame]])
      lDataColumns <- names(lData[[strDataFrame]])
      allCols <- c(allCols, paste(strDataFrame, lSpecColumns, sep = "$"))

      thisMissingCols <- lSpecColumns[!lSpecColumns %in% lDataColumns]
      if (length(thisMissingCols) > 0) {
        missingCols <- c(missingCols, paste(strDataFrame, thisMissingCols, sep = "$"))
      }
    }
  }
  if (length(missingCols) > 0) {
    cli::cli_alert_danger("Not all specified columns in the spec are present in the data, missing columns are: {missingCols}")
  } else if (length(allCols) > 0) {
    cli::cli_alert("All {length(allCols)} specified column{?s} in the spec are present in the data: {allCols}")
  } else {
    cli::cli_alert("No columns specified in the spec. All data.frames are pulling in all available columns.")
  }
}
