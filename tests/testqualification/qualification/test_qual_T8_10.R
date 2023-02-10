test_that("Data entry assessment can return a correctly assessed data frame for the fisher test grouped by the site variable when given correct input data and a site with low enrollment from clindata, and the results should be flagged correctly using a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::DataEntry_Map_Raw()

  nMinDenominator = 24

  test8_10 <- DataEntry_Assess(
    dfInput = dfInput,
    strMethod = "Fisher",
    strGroup = "Site",
    vThreshold = c(0.02, 0.06),
    nMinDenominator = nMinDenominator
  )

  # double programming
  t8_10_input <- dfInput

  t8_10_transformed <- dfInput %>%
    qualification_transform_counts(countCol = "Count",
                                   exposureCol = "Total")

  t8_10_analyzed <- t8_10_transformed %>%
    qualification_analyze_fisher()

  class(t8_10_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t8_10_flagged <- t8_10_analyzed %>%
    qualification_flag_fisher(threshold = c(0.02, 0.06))

  t8_10_summary <- t8_10_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0))) %>%
    mutate(Score = case_when(Denominator >= nMinDenominator ~ Score,
                             Denominator < nMinDenominator ~ NA_real_),
           Flag = case_when(Denominator >= nMinDenominator ~ Flag,
                            Denominator < nMinDenominator ~ NA_real_))


  t8_10 <- list(
    "dfTransformed" = t8_10_transformed,
    "dfAnalyzed" = t8_10_analyzed,
    "dfFlagged" = t8_10_flagged,
    "dfSummary" = t8_10_summary
  )

  # compare results
  expect_equal(test8_10$lData, t8_10)
})
