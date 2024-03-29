test_that("Given appropriate Query Age data, the assessment function correctly performs a Query Age Assessment grouped by a custom variable using the Fisher method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::QueryAge_Map_Raw()

  test9_3 <- QueryAge_Assess(
    dfInput = dfInput,
    strMethod = "Fisher",
    strGroup = "CustomGroup"
  )

  # double programming
  t9_3_input <- dfInput

  t9_3_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total",
      GroupID = "CustomGroupID"
    )

  t9_3_analyzed <- t9_3_transformed %>%
    qualification_analyze_fisher()

  class(t9_3_analyzed) <- c("tbl_df", "tbl", "data.frame")


  t9_3_flagged <- t9_3_analyzed %>%
    qualification_flag_fisher()

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

  # remove metadata that is not part of qualification
  test9_3$lData$dfConfig <- NULL

  # compare results
  expect_equal(test9_3$lData, t9_3)
})
