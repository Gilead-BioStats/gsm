test_that("Data change assessment can return a correctly assessed data frame for the fisher test grouped by the country variable when given correct input data from clindata and the results should be flagged correctly.", {
  # gsm analysis
  dfInput <- gsm::DataChg_Map_Raw()

  test7_6 <- DataChg_Assess(
    dfInput = dfInput,
    strMethod = "Fisher",
    strGroup = "Country"
  )

  # double programming
  t7_6_input <- dfInput

  t7_6_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total",
      GroupID = "CountryID"
    )

  t7_6_analyzed <- t7_6_transformed %>%
    qualification_analyze_fisher()

  class(t7_6_analyzed) <- c("tbl_df", "tbl", "data.frame")


  t7_6_flagged <- t7_6_analyzed %>%
    qualification_flag_fisher()

  t7_6_summary <- t7_6_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t7_6 <- list(
    "dfTransformed" = t7_6_transformed,
    "dfAnalyzed" = t7_6_analyzed,
    "dfFlagged" = t7_6_flagged,
    "dfSummary" = t7_6_summary
  )

  # compare results
  expect_equal(test7_6$lData, t7_6)
})
