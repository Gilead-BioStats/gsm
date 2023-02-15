test_that("PD assessment can return a correctly assessed data frame for the normal approximation test grouped by the site variable when given correct input data and a site with low enrollment from clindata, and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Binary()

  nMinDenominator <- 54

  test23_12 <- PD_Assess_Binary(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    vThreshold = c(-2, -1, 1, 2),
    nMinDenominator = nMinDenominator
  )

  # Double Programming
  t23_12_input <- dfInput

  t23_12_transformed <- dfInput %>%
    qualification_transform_counts(exposureCol = "Total")

  t23_12_analyzed <- t23_12_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t23_12_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t23_12_flagged <- t23_12_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))

  t23_12_summary <- t23_12_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0))) %>%
    mutate(Score = case_when(Denominator >= nMinDenominator ~ Score,
                             Denominator < nMinDenominator ~ NA_real_),
           Flag = case_when(Denominator >= nMinDenominator ~ Flag,
                            Denominator < nMinDenominator ~ NA_real_))

  t23_12 <- list(
    "dfTransformed" = t23_12_transformed,
    "dfAnalyzed" = t23_12_analyzed,
    "dfFlagged" = t23_12_flagged,
    "dfSummary" = t23_12_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test23_12$lData[names(test23_12$lData) != "dfBounds"], t23_12)
})
