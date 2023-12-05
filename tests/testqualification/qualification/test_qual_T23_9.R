test_that("Given appropriate Protocol Deviation data, the assessment function correctly performs a Protocol Deviation Assessment grouped by a custom variable using the Normal Approximation method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Binary()

  test23_9 <- PD_Assess_Binary(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "CustomGroup"
  )

  # Double Programming
  t23_9_input <- dfInput

  t23_9_transformed <- dfInput %>%
    qualification_transform_counts(
      GroupID = "CustomGroupID",
      exposureCol = "Total"
    )

  t23_9_analyzed <- t23_9_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t23_9_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t23_9_flagged <- t23_9_analyzed %>%
    qualification_flag_normalapprox()

  t23_9_summary <- t23_9_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t23_9 <- list(
    "dfTransformed" = t23_9_transformed,
    "dfAnalyzed" = t23_9_analyzed,
    "dfFlagged" = t23_9_flagged,
    "dfSummary" = t23_9_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test23_9$lData[!names(test23_9$lData) %in% c("dfBounds", "dfConfig")], t23_9)
})
