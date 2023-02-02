test_that("PD assessment can return a correctly assessed data frame for the poisson test grouped by the site variable when given correct input data and a site with low enrollment from clindata, and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Binary()

  nMinDenominator <- 54

  test27_10 <- PD_Assess_Binary(
    dfInput = dfInput,
    strMethod = "Poisson",
    vThreshold = c(-3, -1, 1, 3),
    nMinDenominator = nMinDenominator
  )

  # Double Programming
  t27_10_input <- dfInput

  t27_10_transformed <- dfInput %>%
    qualification_transform_counts(exposureCol = "Total")

  t27_10_analyzed <- t27_10_transformed %>%
    qualification_analyze_poisson()

  class(t27_10_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t27_10_flagged <- t27_10_analyzed %>%
    qualification_flag_poisson(threshold = c(-3, -1, 1, 3))

  t27_10_summary <- t27_10_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0))) %>%
    mutate(Score = case_when(Denominator >= nMinDenominator ~ Score,
                             Denominator < nMinDenominator ~ NA_real_),
           Flag = case_when(Denominator >= nMinDenominator ~ Flag,
                            Denominator < nMinDenominator ~ NA_real_))


  t27_10 <- list(
    "dfTransformed" = t27_10_transformed,
    "dfAnalyzed" = t27_10_analyzed,
    "dfFlagged" = t27_10_flagged,
    "dfSummary" = t27_10_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test27_10$lData[names(test27_10$lData) != "dfBounds"], t27_10)
})
