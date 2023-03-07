test_that("Given appropriate Disposition data, the assessment function correctly performs a Disposition Assessment grouped by a custom variable using the Normal Approximation method and correctly assigns Flag variable values when given a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::Disp_Map_Raw()

  test5_7 <- Disp_Assess(
    dfInput = dfInput,
    vThreshold = c(-2, -1, 1, 2),
    strGroup = "CustomGroup",
    strMethod = "NormalApprox"
  )

  # Double Programming
  t5_7_input <- dfInput

  t5_7_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
      GroupID = "CustomGroupID"
    )

  t5_7_analyzed <- t5_7_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t5_7_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_7_flagged <- t5_7_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))

  t5_7_summary <- t5_7_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t5_7 <- list(
    "dfTransformed" = t5_7_transformed,
    "dfAnalyzed" = t5_7_analyzed,
    "dfFlagged" = t5_7_flagged,
    "dfSummary" = t5_7_summary
  )

  # compare results
  expect_equal(test5_7$lData[!names(test5_7$lData) == "dfBounds"], t5_7)
})
