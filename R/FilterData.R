function(dfInput, strCol, anyVal, bReturnChecks = FALSE, bQuiet = TRUE) {
  stopifnot(
    `[ dfInput ] must be a data frame.` = is.data.frame(dfInput),
    `[ strCol ] must be character.` = is.character(strCol),
    `[ strCol ] must be have only one element.` = length(strCol) ==
      1, `[ dfInput ] must have a column named [ strCol ].` = strCol %in%
      names(dfInput), `[ anyVal ] must have at least one element.` = length(anyVal) >
      0, `[ dfInput[[ strCol ]] ] and [ anyVal ] must be of the same class.` = any(class(dfInput[[strCol]]) %in%
      class(anyVal)), `[ bQuiet ] must be logical` = is.logical(bQuiet)
  )
  if (!bQuiet) {
    cli::cli_text("Applying subset: `{strCol} %in% (\"{paste(anyVal, collapse = '\", \"')}\")`")
  }
  oldRows <- nrow(dfInput)
  dfOutput <- dfInput[dfInput[[strCol]] %in% anyVal, ]
  newRows <- nrow(dfOutput)
  if (!bQuiet) {
    cli::cli_alert_success("Subset removed {oldRows - newRows} rows from {oldRows} to {newRows} rows.")
    if (newRows == 0) {
      cli::cli_alert_warning("WARNING: Subset removed all rows.")
    }
    if (newRows == oldRows) {
      cli::cli_alert_info("NOTE: Subset removed 0 rows.")
    }
  }
  if (bReturnChecks) {
    return(list(df = dfOutput, lChecks = list(status = TRUE)))
  }
  dfOutput
}
