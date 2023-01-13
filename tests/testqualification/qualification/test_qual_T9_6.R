test_that("Query age assessment can return a correctly assessed data frame for the fisher test grouped by the country variable when given correct input data from clindata and the results should be flagged correctly.", {
  # gsm analysis
  dfInput <- gsm::QueryAge_Map_Raw()

  test9_6 <- QueryAge_Assess(
    dfInput = dfInput,
    strMethod = "Fisher",
    strGroup = "Country"
  )

  # double programming
  t9_6_input <- dfInput

  t9_6_transformed <- dfInput %>%
    qualification_transform_counts(countCol = "Count",
                                   exposureCol = "Total",
                                   GroupID = "CountryID")

  t9_6_analyzed <- t9_6_transformed %>%
    qualification_analyze_fisher()

  class(t9_6_analyzed) <- c("tbl_df", "tbl", "data.frame")


  t9_6_flagged <- t9_6_analyzed %>%
    qualification_flag_fisher()

  t9_6_summary <- t9_6_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t9_6 <- list(
    "dfTransformed" = t9_6_transformed,
    "dfAnalyzed" = t9_6_analyzed,
    "dfFlagged" = t9_6_flagged,
    "dfSummary" = t9_6_summary
  )

  # compare results
  expect_equal(test9_6$lData, t9_6)
})
