test_that("Given appropriate Data Change Rate data, the assessment function correctly performs a Data Change Rate Assessment grouped by a custom variable using the Fisher method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::DataChg_Map_Raw()

  test7_3 <- DataChg_Assess(
    dfInput = dfInput,
    strMethod = "Fisher",
    strGroup = "CustomGroup"
  )

  # double programming
  t7_3_input <- dfInput

  t7_3_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total",
      GroupID = "CustomGroupID"
    )

  t7_3_analyzed <- t7_3_transformed %>%
    qualification_analyze_fisher()

  class(t7_3_analyzed) <- c("tbl_df", "tbl", "data.frame")


  t7_3_flagged <- t7_3_analyzed %>%
    qualification_flag_fisher()

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

  # remove metadata that is not part of qualification
  test7_3$lData$dfConfig <- NULL

  # compare results
  expect_equal(test7_3$lData, t7_3)
})
