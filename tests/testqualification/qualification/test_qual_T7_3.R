test_that("Data change assessment can return a correctly assessed data frame for the identity test grouped by the country variable when given subset input data from clindata and the results should be flagged correctly.", {
  # gsm analysis
  dfInput <- gsm::DataChg_Map_Raw()

  test7_3 <- DataChg_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "Country"
  )

  # double programming
  t7_3_input <- dfInput

  t7_3_transformed <- dfInput %>%
    qualification_transform_counts(countCol = "Count",
                                   exposureCol = "Total",
                                   GroupID = "CountryID")

  t7_3_analyzed <- t7_3_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t7_3_analyzed) <- c("tbl_df", "tbl", "data.frame")


  t7_3_flagged <- t7_3_analyzed %>%
    qualification_flag_identity()

  t7_3_summary <- t7_3_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t7_3 <- list(
    "dfTransformed" = t7_3_transformed,
    "dfAnalyzed" = t7_3_analyzed,
    "dfFlagged" = t7_3_flagged,
    "dfSummary" = t7_3_summary
  )

  # compare results
  expect_equal(test7_3$lData, t7_3)
})
