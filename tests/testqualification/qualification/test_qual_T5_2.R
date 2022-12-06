test_that("Disposition assessment can return a correctly assessed data frame for the fisher test grouped by a custom variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- gsm::Disp_Map_Raw()

  test5_2 <- Disp_Assess(
    dfInput = dfInput,
    vThreshold = c(.025, .05),
    strGroup = "CustomGroup",
    strMethod = "Fisher"
  )

  # Double Programming
  t5_2_input <- dfInput

  t5_2_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
      GroupID = "CustomGroupID"
    )

  t5_2_analyzed <- t5_2_transformed %>%
    qualification_analyze_fisher()

  class(t5_2_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_2_flagged <- t5_2_analyzed %>%
    qualification_flag_fisher(threshold = c(.025, .05))

  t5_2_summary <- t5_2_flagged %>%
    select(GroupID, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t5_2 <- list(
    "dfTransformed" = t5_2_transformed,
    "dfAnalyzed" = t5_2_analyzed,
    "dfFlagged" = t5_2_flagged,
    "dfSummary" = t5_2_summary
  )

  # compare results
  expect_equal(test5_2$lData, t5_2)
})
