function(
    dfTransformed, nConfLevel = 0.95, strOutcome = "binary",
    bQuiet = TRUE) {
  stopifnot(
    `dfTransformed is not a data.frame` = is.data.frame(dfTransformed),
    `One or more of these columns: GroupID, Numerator, or Denominator not found in dfTransformed` = all(c(
      "GroupID",
      "Numerator", "Denominator"
    ) %in% names(dfTransformed)),
    `NA value(s) found in GroupID` = all(!is.na(dfTransformed[["GroupID"]]))
  )
  if (strOutcome == "binary") {
    lModel <- stats::binom.test(dfTransformed$Numerator,
      dfTransformed$Denominator,
      alternative = "two.sided",
      conf.level = nConfLevel
    )
  }
  if (strOutcome == "rate") {
    lModel <- stats::poisson.test(dfTransformed$Numerator,
      T = dfTransformed$Denominator, alternative = "two.sided",
      conf.level = nConfLevel
    )
  }
  dfAnalyzed <- dfTransformed %>%
    bind_cols(
      Method = lModel$method,
      ConfLevel = nConfLevel, Estimate = lModel$estimate, LowCI = lModel$conf.int[1],
      UpCI = lModel$conf.int[2],
    ) %>%
    mutate(Score = .data$LowCI)
  return(dfAnalyzed)
}
