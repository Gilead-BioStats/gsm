test_that("Query age assessment can return a correctly assessed data frame for the identity test grouped by the site variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::QueryAge_Map_Raw()

  test9_1 <- QueryAge_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "Site",
    vThreshold = c(0.00006, 0.01)
  )

  # double programming
  t9_1_input <- dfInput

  t9_1_transformed <- dfInput %>%
    qualification_transform_counts(countCol = "Count",
                                   exposureCol = "Total")

  t9_1_analyzed <- t9_1_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t9_1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t9_1_flagged <- t9_1_analyzed %>%
    qualification_flag_identity(threshold = c(0.00006, 0.01))

  t9_1_summary <- t9_1_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t9_1 <- list(
    "dfTransformed" = t9_1_transformed,
    "dfAnalyzed" = t9_1_analyzed,
    "dfFlagged" = t9_1_flagged,
    "dfSummary" = t9_1_summary
  )

  # compare results
  expect_equal(test9_1$lData, t9_1)
})
