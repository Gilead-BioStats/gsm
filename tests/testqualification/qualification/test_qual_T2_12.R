test_that("PD assessment can return a correctly assessed data frame for the normal approximation test grouped by the site variable when given correct input data and a site with low enrollment from clindata, and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw()

  nMinDenominator <- 54

  test2_12 <- PD_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    vThreshold = c(-2, -1, 1, 2),
    nMinDenominator = nMinDenominator
  )

  # Double Programming
  t2_12_input <- dfInput

  t2_12_transformed <- dfInput %>%
    qualification_transform_counts()

  t2_12_analyzed <- t2_12_transformed %>%
    qualification_analyze_normalapprox(strType = "rate")

  class(t2_12_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t2_12_flagged <- t2_12_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))

  t2_12_summary <- t2_12_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0))) %>%
    mutate(Score = case_when(Denominator >= nMinDenominator ~ Score,
                             Denominator < nMinDenominator ~ NA_real_),
           Flag = case_when(Denominator >= nMinDenominator ~ Flag,
                            Denominator < nMinDenominator ~ NA_real_))

  t2_12 <- list(
    "dfTransformed" = t2_12_transformed,
    "dfAnalyzed" = t2_12_analyzed,
    "dfFlagged" = t2_12_flagged,
    "dfSummary" = t2_12_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test2_12$lData[names(test2_12$lData) != "dfBounds"], t2_12)
})
