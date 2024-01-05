test_that("Given appropriate Data Entry Lag data, the assessment function correctly performs a Data Entry Lag Assessment grouped by a custom variable using the Fisher method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::DataEntry_Map_Raw()

  test8_3 <- DataEntry_Assess(
    dfInput = dfInput,
    strMethod = "Fisher",
    strGroup = "CustomGroup"
  )

  # double programming
  t8_3_input <- dfInput

  t8_3_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total",
      GroupID = "CustomGroupID"
    )

  t8_3_analyzed <- t8_3_transformed %>%
    qualification_analyze_fisher()

  class(t8_3_analyzed) <- c("tbl_df", "tbl", "data.frame")


  t8_3_flagged <- t8_3_analyzed %>%
    qualification_flag_fisher()

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

  # remove metadata that is not part of qualification
  test8_3$lData$dfConfig <- NULL

  # compare results
  expect_equal(test8_3$lData, t8_3)
})
