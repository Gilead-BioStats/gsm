test_that("Given appropriate Data Change Rate data, the assessment function correctly performs a Data Change Rate Assessment grouped by a custom variable using the Normal Approximation method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::DataChg_Map_Raw()

  test7_9 <- DataChg_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "CustomGroup"
  )

  # double programming
  t7_9_input <- dfInput

  t7_9_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total",
      GroupID = "CustomGroupID"
    )

  t7_9_analyzed <- t7_9_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t7_9_analyzed) <- c("tbl_df", "tbl", "data.frame")


  t7_9_flagged <- t7_9_analyzed %>%
    qualification_flag_normalapprox()

  t7_9_summary <- t7_9_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t7_9 <- list(
    "dfTransformed" = t7_9_transformed,
    "dfAnalyzed" = t7_9_analyzed,
    "dfFlagged" = t7_9_flagged,
    "dfSummary" = t7_9_summary
  )

  # compare results
  expect_equal(test7_9$lData[names(test7_9$lData) != "dfBounds"], t7_9)
})
