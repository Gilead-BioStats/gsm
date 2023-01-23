test_that("Query rate assessment can return a correctly assessed data frame for the poisson test grouped by the site variable when given correct input data and a site with low enrollment from clindata, and the results should be flagged correctly using a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::QueryRate_Map_Raw()

  nMinDenominator <- 196

  test10_11 <- QueryRate_Assess(
    dfInput = dfInput,
    strMethod = "Poisson",
    strGroup = "Site",
    vThreshold = c(-6, -4, 4, 6),
    nMinDenominator = nMinDenominator
  )

  # double programming
  t10_11_input <- dfInput

  t10_11_transformed <- dfInput %>%
    qualification_transform_counts(countCol = "Count",
                                   exposureCol = "DataPoint")

  t10_11_analyzed <- t10_11_transformed %>%
    qualification_analyze_poisson()

  class(t10_11_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t10_11_flagged <- t10_11_analyzed %>%
    qualification_flag_poisson(threshold = c(-6, -4, 4, 6))

  t10_11_summary <- t10_11_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0))) %>%
    mutate(Score = case_when(Denominator >= nMinDenominator ~ Score,
                             Denominator < nMinDenominator ~ NA_real_),
           Flag = case_when(Denominator >= nMinDenominator ~ Flag,
                            Denominator < nMinDenominator ~ NA_real_))


  t10_11 <- list(
    "dfTransformed" = t10_11_transformed,
    "dfAnalyzed" = t10_11_analyzed,
    "dfFlagged" = t10_11_flagged,
    "dfSummary" = t10_11_summary
  )

  # compare results
  expect_equal(test10_11$lData[names(test10_11$lData) != "dfBounds"], t10_11)
})
