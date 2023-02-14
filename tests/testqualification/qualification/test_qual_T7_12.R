test_that("Data change assessment can return a correctly assessed data frame for the normal approximation test grouped by the site variable when given correct input data and a site with low enrollment from clindata, and the results should be flagged correctly using a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::DataChg_Map_Raw()

  nMinDenominator <- 97

  test7_12 <- DataChg_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "Site",
    vThreshold = c(-2, -1, 1, 2),
    nMinDenominator = nMinDenominator
  )

  # double programming
  t7_12_input <- dfInput

  t7_12_transformed <- dfInput %>%
    qualification_transform_counts(countCol = "Count",
                                   exposureCol = "Total")

  t7_12_analyzed <- t7_12_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t7_12_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t7_12_flagged <- t7_12_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))

  t7_12_summary <- t7_12_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0))) %>%
    mutate(Score = case_when(Denominator >= nMinDenominator ~ Score,
                             Denominator < nMinDenominator ~ NA_real_),
           Flag = case_when(Denominator >= nMinDenominator ~ Flag,
                            Denominator < nMinDenominator ~ NA_real_))


  t7_12 <- list(
    "dfTransformed" = t7_12_transformed,
    "dfAnalyzed" = t7_12_analyzed,
    "dfFlagged" = t7_12_flagged,
    "dfSummary" = t7_12_summary
  )

  # compare results
  expect_equal(test7_12$lData[names(test7_12$lData) != "dfBounds"], t7_12)
})
