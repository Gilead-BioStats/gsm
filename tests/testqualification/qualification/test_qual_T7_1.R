test_that("Data change assessment can return a correctly assessed data frame for the identity test grouped by the site variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::DataChg_Map_Raw()

  test7_1 <- DataChg_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "Site",
    vThreshold = c(0.00006, 0.01)
  )

  # double programming
  t7_1_input <- dfInput

  t7_1_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total"
    )

  t7_1_analyzed <- t7_1_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t7_1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t7_1_flagged <- t7_1_analyzed %>%
    qualification_flag_identity(threshold = c(0.00006, 0.01))

  t7_1_summary <- t7_1_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t7_1 <- list(
    "dfTransformed" = t7_1_transformed,
    "dfAnalyzed" = t7_1_analyzed,
    "dfFlagged" = t7_1_flagged,
    "dfSummary" = t7_1_summary
  )

  # compare results
  expect_equal(test7_1$lData, t7_1)
})
