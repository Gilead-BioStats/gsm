test_that("Query rate assessment can return a correctly assessed data frame for the identity test grouped by the country variable when given correct input data from clindata and the results should be flagged correctly.", {
  # gsm analysis
  dfInput <- gsm::QueryRate_Map_Raw()

  test10_3 <- QueryRate_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "Country"
  )

  # double programming
  t10_3_input <- dfInput

  t10_3_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "DataPoint",
      GroupID = "CountryID"
    )

  t10_3_analyzed <- t10_3_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t10_3_analyzed) <- c("tbl_df", "tbl", "data.frame")


  t10_3_flagged <- t10_3_analyzed %>%
    qualification_flag_identity(threshold = c(0.00006, 0.01))

  t10_3_summary <- t10_3_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t10_3 <- list(
    "dfTransformed" = t10_3_transformed,
    "dfAnalyzed" = t10_3_analyzed,
    "dfFlagged" = t10_3_flagged,
    "dfSummary" = t10_3_summary
  )

  # compare results
  expect_equal(test10_3$lData, t10_3)
})
