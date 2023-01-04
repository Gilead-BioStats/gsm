test_that("Disposition assessment can return a correctly assessed data frame for the fisher test grouped by the site variable when given correct input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- gsm::Disp_Map_Raw()

  test5_1 <- Disp_Assess(
    dfInput = dfInput,
    strMethod = "fisher"
  )

  # Double Programming
  t5_1_input <- dfInput

  t5_1_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total"
    )

  t5_1_analyzed <- t5_1_transformed %>%
    qualification_analyze_fisher()

  class(t5_1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_1_flagged <- t5_1_analyzed %>%
    qualification_flag_fisher()

  t5_1_summary <- t5_1_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t5_1 <- list(
    "dfTransformed" = t5_1_transformed,
    "dfAnalyzed" = t5_1_analyzed,
    "dfFlagged" = t5_1_flagged,
    "dfSummary" = t5_1_summary
  )

  # compare results
  expect_equal(test5_1$lData, t5_1)
})
