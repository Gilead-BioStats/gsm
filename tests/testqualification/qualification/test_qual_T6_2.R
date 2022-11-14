test_that("Labs assessment can return a correctly assessed data frame for the chisq test grouped by a custom variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- gsm::LB_Map_Raw()

  test6_2 <- LB_Assess(
    dfInput = dfInput,
    vThreshold = c(.025, .05),
    strGroup = "CustomGroup",
    strMethod = "fisher"
  )

  # Double Programming
  t6_2_input <- dfInput

  t6_2_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
      GroupID = "CustomGroupID"
    )

  t6_2_analyzed <- t6_2_transformed %>%
    qualification_analyze_fisher()

  class(t6_2_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_2_flagged <- t6_2_analyzed %>%
    qualification_flag_fisher(threshold = c(.025, .05))

  t6_2_summary <- t6_2_flagged %>%
    select(GroupID, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t6_2 <- list(
    "dfTransformed" = t6_2_transformed,
    "dfAnalyzed" = t6_2_analyzed,
    "dfFlagged" = t6_2_flagged,
    "dfSummary" = t6_2_summary
  )

  # compare results
  expect_equal(test6_2$lData, t6_2)
})
