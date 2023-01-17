test_that("Data entry assessment can return a correctly assessed data frame for the identity test grouped by the site variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::DataEntry_Map_Raw()

  test8_1 <- DataEntry_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "Site",
    vThreshold = c(0.00006, 0.01)
  )

  # double programming
  t8_1_input <- dfInput

  t8_1_transformed <- dfInput %>%
    qualification_transform_counts(countCol = "Count",
                                   exposureCol = "Total")

  t8_1_analyzed <- t8_1_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t8_1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t8_1_flagged <- t8_1_analyzed %>%
    qualification_flag_identity(threshold = c(0.00006, 0.01))

  t8_1_summary <- t8_1_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t8_1 <- list(
    "dfTransformed" = t8_1_transformed,
    "dfAnalyzed" = t8_1_analyzed,
    "dfFlagged" = t8_1_flagged,
    "dfSummary" = t8_1_summary
  )

  # compare results
  expect_equal(test8_1$lData, t8_1)
})
