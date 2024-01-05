test_that("Given appropriate Query Age data, the assessment function correctly performs a Query Age Assessment grouped by a custom variable using the Normal Approximation method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::QueryAge_Map_Raw()

  test9_9 <- QueryAge_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "CustomGroup"
  )

  # double programming
  t9_9_input <- dfInput

  t9_9_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total",
      GroupID = "CustomGroupID"
    )

  t9_9_analyzed <- t9_9_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t9_9_analyzed) <- c("tbl_df", "tbl", "data.frame")


  t9_9_flagged <- t9_9_analyzed %>%
    qualification_flag_normalapprox()

  t9_9_summary <- t9_9_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t9_9 <- list(
    "dfTransformed" = t9_9_transformed,
    "dfAnalyzed" = t9_9_analyzed,
    "dfFlagged" = t9_9_flagged,
    "dfSummary" = t9_9_summary
  )

  # remove metadata that is not part of qualification
  test9_9$lData$dfConfig <- NULL

  # compare results
  expect_equal(test9_9$lData[names(test9_9$lData) != "dfBounds"], t9_9)
})
