test_that("Given appropriate Query Age data, the assessment function correctly performs a Query Age Assessment grouped by a custom variable using the Identity method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::QueryAge_Map_Raw()

  test9_6 <- QueryAge_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "CustomGroup"
  )

  # double programming
  t9_6_input <- dfInput

  t9_6_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total",
      GroupID = "CustomGroupID"
    )

  t9_6_analyzed <- t9_6_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t9_6_analyzed) <- c("tbl_df", "tbl", "data.frame")


  t9_6_flagged <- t9_6_analyzed %>%
    qualification_flag_identity()

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

  # remove metadata that is not part of qualification
  test9_6$lData$dfConfig <- NULL

  # compare results
  expect_equal(test9_6$lData, t9_6)
})
