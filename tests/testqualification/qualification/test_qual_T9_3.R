test_that("Query age assessment can return a correctly assessed data frame for the identity test grouped by the country variable when given subset input data from clindata and the results should be flagged correctly.", {
  # gsm analysis
  dfInput <- gsm::QueryAge_Map_Raw()

  test9_3 <- QueryAge_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "Country"
  )

  # double programming
  t9_3_input <- dfInput

  t9_3_transformed <- dfInput %>%
    qualification_transform_counts(countCol = "Count",
                                   exposureCol = "Total",
                                   GroupID = "CountryID")

  t9_3_analyzed <- t9_3_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t9_3_analyzed) <- c("tbl_df", "tbl", "data.frame")


  t9_3_flagged <- t9_3_analyzed %>%
    qualification_flag_identity()

  t9_3_summary <- t9_3_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t9_3 <- list(
    "dfTransformed" = t9_3_transformed,
    "dfAnalyzed" = t9_3_analyzed,
    "dfFlagged" = t9_3_flagged,
    "dfSummary" = t9_3_summary
  )

  # compare results
  expect_equal(test9_3$lData, t9_3)
})
