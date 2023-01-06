test_that("AE assessment can return a correctly assessed data frame for the poisson test grouped by the poissonsite variable when given correct input data from safetyData and the results should be flagged correctly.", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Adam()

  test1_1 <- AE_Assess(
    dfInput = dfInput,
    strMethod = "Poisson"
  )

  # Double Programming
  t1_input <- dfInput

  t1_transformed <- dfInput %>%
    qualification_transform_counts()

  t1_analyzed <- t1_transformed %>%
    qualification_analyze_poisson()

  class(t1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t1_flagged <- t1_analyzed %>%
    qualification_flag_poisson()

  t1_summary <- t1_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t1_1 <- list(
    "dfTransformed" = t1_transformed,
    "dfAnalyzed" = t1_analyzed,
    "dfFlagged" = t1_flagged,
    "dfSummary" = t1_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test1_1$lData[names(test1_1$lData) != "dfBounds"], t1_1)
})
