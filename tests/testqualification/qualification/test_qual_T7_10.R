test_that("Data change assessment can return a correctly assessed data frame for the identity test grouped by the site variable when given correct input data and a site with low enrollment from clindata, and the results should be flagged correctly using a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::DataChg_Map_Raw()

  nMinDenominator <- 197

  test7_10 <- DataChg_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "Site",
    vThreshold = c(0.00006, 0.01),
    nMinDenominator = nMinDenominator
  )

  # double programming
  t7_10_input <- dfInput

  t7_10_transformed <- dfInput %>%
    qualification_transform_counts(countCol = "Count",
                                   exposureCol = "Total")

  t7_10_analyzed <- t7_10_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t7_10_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t7_10_flagged <- t7_10_analyzed %>%
    qualification_flag_identity(threshold = c(0.00006, 0.01))

  t7_10_summary <- t7_10_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0))) %>%
    mutate(Score = case_when(Denominator >= nMinDenominator ~ Score,
                             Denominator < nMinDenominator ~ NA_real_),
           Flag = case_when(Denominator >= nMinDenominator ~ Flag,
                            Denominator < nMinDenominator ~ NA_real_))


  t7_10 <- list(
    "dfTransformed" = t7_10_transformed,
    "dfAnalyzed" = t7_10_analyzed,
    "dfFlagged" = t7_10_flagged,
    "dfSummary" = t7_10_summary
  )

  # compare results
  expect_equal(test7_10$lData, t7_10)
})
