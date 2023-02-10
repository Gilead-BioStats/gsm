test_that("PD assessment can return a correctly assessed data frame for the poisson test grouped by the site variable when given correct input data and a site with low enrollment from clindata, and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Binary()

  nMinDenominator <- 54

  test23_10 <- PD_Assess_Binary(
    dfInput = dfInput,
    strMethod = "Poisson",
    vThreshold = c(-3, -1, 1, 3),
    nMinDenominator = nMinDenominator
  )

  # Double Programming
  t23_10_input <- dfInput

  t23_10_transformed <- dfInput %>%
    qualification_transform_counts(exposureCol = "Total")

  t23_10_analyzed <- t23_10_transformed %>%
    qualification_analyze_poisson()

  class(t23_10_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t23_10_flagged <- t23_10_analyzed %>%
    qualification_flag_poisson(threshold = c(-3, -1, 1, 3))

  t23_10_summary <- t23_10_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0))) %>%
    mutate(Score = case_when(Denominator >= nMinDenominator ~ Score,
                             Denominator < nMinDenominator ~ NA_real_),
           Flag = case_when(Denominator >= nMinDenominator ~ Flag,
                            Denominator < nMinDenominator ~ NA_real_))


  t23_10 <- list(
    "dfTransformed" = t23_10_transformed,
    "dfAnalyzed" = t23_10_analyzed,
    "dfFlagged" = t23_10_flagged,
    "dfSummary" = t23_10_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test23_10$lData[names(test23_10$lData) != "dfBounds"], t23_10)
})
