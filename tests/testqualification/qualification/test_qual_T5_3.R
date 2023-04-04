test_that("Given appropriate Disposition data, the assessment function correctly performs a Disposition Assessment grouped by a custom variable using the Fisher method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::Disp_Map_Raw()

  test5_3 <- Disp_Assess(
    dfInput = dfInput,
    strGroup = "CustomGroup",
    strMethod = "Fisher"
  )

  # Double Programming
  t5_3_input <- dfInput

  t5_3_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
      GroupID = "CustomGroupID"
    )

  t5_3_analyzed <- t5_3_transformed %>%
    qualification_analyze_fisher()

  class(t5_3_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_3_flagged <- t5_3_analyzed %>%
    qualification_flag_fisher()

  t5_3_summary <- t5_3_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t5_3 <- list(
    "dfTransformed" = t5_3_transformed,
    "dfAnalyzed" = t5_3_analyzed,
    "dfFlagged" = t5_3_flagged,
    "dfSummary" = t5_3_summary
  )

  # compare results
  expect_equal(test5_3$lData, t5_3)
})
