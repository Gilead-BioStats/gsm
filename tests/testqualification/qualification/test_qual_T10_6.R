test_that("Given appropriate Query Rate data, the assessment function correctly performs a Query Rate Assessment grouped by the Country variable using the Identity method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::QueryRate_Map_Raw()

  test10_6 <- QueryRate_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "Country"
  )

  # double programming
  t10_6_input <- dfInput

  t10_6_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "DataPoint",
      GroupID = "CountryID"
    )

  t10_6_analyzed <- t10_6_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t10_6_analyzed) <- c("tbl_df", "tbl", "data.frame")


  t10_6_flagged <- t10_6_analyzed %>%
    qualification_flag_identity(threshold = c(0.00006, 0.01))

  t10_6_summary <- t10_6_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t10_6 <- list(
    "dfTransformed" = t10_6_transformed,
    "dfAnalyzed" = t10_6_analyzed,
    "dfFlagged" = t10_6_flagged,
    "dfSummary" = t10_6_summary
  )

  # compare results
  expect_equal(test10_6$lData, t10_6)
})
