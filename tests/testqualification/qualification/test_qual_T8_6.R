test_that("Data entry assessment can return a correctly assessed data frame for the fisher test grouped by the country variable when given subset input data from clindata and the results should be flagged correctly.", {
  # gsm analysis
  dfInput <- gsm::DataEntry_Map_Raw()

  test8_6 <- DataEntry_Assess(
    dfInput = dfInput,
    strMethod = "Fisher",
    strGroup = "Country"
  )

  # double programming
  t8_6_input <- dfInput

  t8_6_transformed <- dfInput %>%
    qualification_transform_counts(countCol = "Count",
                                   exposureCol = "Total",
                                   GroupID = "CountryID")

  t8_6_analyzed <- t8_6_transformed %>%
    qualification_analyze_fisher()

  class(t8_6_analyzed) <- c("tbl_df", "tbl", "data.frame")


  t8_6_flagged <- t8_6_analyzed %>%
    qualification_flag_fisher()

  t8_6_summary <- t8_6_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t8_6 <- list(
    "dfTransformed" = t8_6_transformed,
    "dfAnalyzed" = t8_6_analyzed,
    "dfFlagged" = t8_6_flagged,
    "dfSummary" = t8_6_summary
  )

  # compare results
  expect_equal(test8_6$lData, t8_6)
})
