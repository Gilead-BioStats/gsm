test_that("Given appropriate Data Entry Lag data, the assessment function correctly performs a Data Entry Lag Assessment grouped by the Site variable using the Normal Approximation method and correctly assigns Flag variable values when given a custom threshold, and Flag variable values are set to NA for sites with low enrollment.", {
  # gsm analysis
  dfInput <- gsm::DataEntry_Map_Raw()

  nMinDenominator <- 24

  test8_12 <- DataEntry_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "Site",
    vThreshold = c(-2, -1, 1, 2),
    nMinDenominator = nMinDenominator
  )

  # double programming
  t8_12_input <- dfInput

  t8_12_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total"
    )

  t8_12_analyzed <- t8_12_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t8_12_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t8_12_flagged <- t8_12_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))

  t8_12_summary <- t8_12_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0))) %>%
    mutate(
      Score = case_when(
        Denominator >= nMinDenominator ~ Score,
        Denominator < nMinDenominator ~ NA_real_
      ),
      Flag = case_when(
        Denominator >= nMinDenominator ~ Flag,
        Denominator < nMinDenominator ~ NA_real_
      )
    )


  t8_12 <- list(
    "dfTransformed" = t8_12_transformed,
    "dfAnalyzed" = t8_12_analyzed,
    "dfFlagged" = t8_12_flagged,
    "dfSummary" = t8_12_summary
  )

  # compare results
  expect_equal(test8_12$lData[names(test8_12$lData) != "dfBounds"], t8_12)
})
