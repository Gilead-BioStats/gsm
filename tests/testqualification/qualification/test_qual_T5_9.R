test_that("Given appropriate Disposition data, the assessment function correctly performs a Disposition Assessment grouped by a custom variable using the Normal Approximation method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::Disp_Map_Raw()

  test5_9 <- Disp_Assess(
    dfInput = dfInput,
    strGroup = "CustomGroup",
    strMethod = "NormalApprox"
  )

  # Double Programming
  t5_9_input <- dfInput

  t5_9_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
      GroupID = "CustomGroupID"
    )

  t5_9_analyzed <- t5_9_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t5_9_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_9_flagged <- t5_9_analyzed %>%
    qualification_flag_normalapprox()

  t5_9_summary <- t5_9_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t5_9 <- list(
    "dfTransformed" = t5_9_transformed,
    "dfAnalyzed" = t5_9_analyzed,
    "dfFlagged" = t5_9_flagged,
    "dfSummary" = t5_9_summary
  )

  # compare results
  expect_equal(test5_9$lData[!names(test5_9$lData) %in% c("dfBounds", "dfConfig")], t5_9)
})
