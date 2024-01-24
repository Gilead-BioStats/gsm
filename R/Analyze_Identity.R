function(dfTransformed, strValueCol = "Metric", bQuiet = TRUE) {
  stopifnot(
    `dfTransformed is not a data.frame` = is.data.frame(dfTransformed),
    `strValueCol not found in dfTransformed` = strValueCol %in%
      names(dfTransformed), `bQuiet must be locial` = is.logical(bQuiet)
  )
  dfAnalyzed <- dfTransformed %>%
    mutate(Score = .data[[strValueCol]]) %>%
    arrange(.data$Score)
  if (!bQuiet) {
    cli::cli_text(paste0(
      "{.var Score} column created from `",
      strValueCol, "`."
    ))
  }
  return(dfAnalyzed)
}
