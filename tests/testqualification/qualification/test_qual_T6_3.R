test_that("Given appropriate Labs data, the assessment function correctly performs a Labs Assessment grouped by a custom variable using the Fisher method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::LB_Map_Raw()

  test6_3 <- LB_Assess(
    dfInput = dfInput,
    strGroup = "CustomGroup",
    strMethod = "Fisher"
  )

  # Double Programming
  t6_3_input <- dfInput

  t6_3_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
      GroupID = "CustomGroupID"
    )

  t6_3_analyzed <- t6_3_transformed %>%
    qualification_analyze_fisher()

  class(t6_3_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_3_flagged <- t6_3_analyzed %>%
    qualification_flag_fisher()

  t6_3_summary <- t6_3_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t6_3 <- list(
    "dfTransformed" = t6_3_transformed,
    "dfAnalyzed" = t6_3_analyzed,
    "dfFlagged" = t6_3_flagged,
    "dfSummary" = t6_3_summary
  )

  # compare results
  expect_equal(test6_3$lData, t6_3)
})
