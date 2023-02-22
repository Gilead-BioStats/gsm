test_that("Query rate assessment can return a correctly assessed data frame for the normal approximation test grouped by the site variable when given correct input data and a site with low enrollment from clindata, and the results should be flagged correctly using a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::QueryRate_Map_Raw()

  nMinDenominator <- 196

  test10_12 <- QueryRate_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "Site",
    vThreshold = c(-2, -1, 1, 2),
    nMinDenominator = nMinDenominator
  )

  # double programming
  t10_12_input <- dfInput

  t10_12_transformed <- dfInput %>%
    qualification_transform_counts(countCol = "Count",
                                   exposureCol = "DataPoint")

  t10_12_analyzed <- t10_12_transformed %>%
    qualification_analyze_normalapprox(strType = "rate")

  class(t10_12_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t10_12_flagged <- t10_12_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))

  t10_12_summary <- t10_12_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0))) %>%
    mutate(Score = case_when(Denominator >= nMinDenominator ~ Score,
                             Denominator < nMinDenominator ~ NA_real_),
           Flag = case_when(Denominator >= nMinDenominator ~ Flag,
                            Denominator < nMinDenominator ~ NA_real_))


  t10_12 <- list(
    "dfTransformed" = t10_12_transformed,
    "dfAnalyzed" = t10_12_analyzed,
    "dfFlagged" = t10_12_flagged,
    "dfSummary" = t10_12_summary
  )

  # compare results
  expect_equal(test10_12$lData[names(test10_12$lData) != "dfBounds"], t10_12)
})
