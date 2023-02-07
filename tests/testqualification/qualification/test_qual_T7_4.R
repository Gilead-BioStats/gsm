test_that("Data change assessment can return a correctly assessed data frame for the fisher test grouped by the site variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::DataChg_Map_Raw()

  test7_4 <- DataChg_Assess(
    dfInput = dfInput,
    strMethod = "Fisher",
    strGroup = "Site",
    vThreshold = c(0.02, 0.06)
  )

  # double programming
  t7_4_input <- dfInput

  t7_4_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total"
    )

  t7_4_analyzed <- t7_4_transformed %>%
    qualification_analyze_fisher()

  class(t7_4_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t7_4_flagged <- t7_4_analyzed %>%
    qualification_flag_fisher(threshold = c(0.02, 0.06))

  t7_4_summary <- t7_4_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t7_4 <- list(
    "dfTransformed" = t7_4_transformed,
    "dfAnalyzed" = t7_4_analyzed,
    "dfFlagged" = t7_4_flagged,
    "dfSummary" = t7_4_summary
  )

  # compare results
  expect_equal(test7_4$lData, t7_4)
})
