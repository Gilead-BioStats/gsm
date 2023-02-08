test_that("Data entry assessment can return a correctly assessed data frame for the identity test grouped by the country variable when given correct input data from clindata and the results should be flagged correctly.", {
  # gsm analysis
  dfInput <- gsm::DataEntry_Map_Raw()

  test8_3 <- DataEntry_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "Country"
  )

  # double programming
  t8_3_input <- dfInput

  t8_3_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total",
      GroupID = "CountryID"
    )

  t8_3_analyzed <- t8_3_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t8_3_analyzed) <- c("tbl_df", "tbl", "data.frame")


  t8_3_flagged <- t8_3_analyzed %>%
    qualification_flag_identity()

  t8_3_summary <- t8_3_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t8_3 <- list(
    "dfTransformed" = t8_3_transformed,
    "dfAnalyzed" = t8_3_analyzed,
    "dfFlagged" = t8_3_flagged,
    "dfSummary" = t8_3_summary
  )

  # compare results
  expect_equal(test8_3$lData, t8_3)
})
