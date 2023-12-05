test_that("Given appropriate Labs data, the assessment function correctly performs a Labs Assessment grouped by a custom variable using the Identity method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::LB_Map_Raw()

  test6_6 <- LB_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "CustomGroup"
  )

  # Double Programming
  t6_6_input <- dfInput

  t6_6_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
      GroupID = "CustomGroupID"
    )

  t6_6_analyzed <- t6_6_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t6_6_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_6_flagged <- t6_6_analyzed %>%
    qualification_flag_identity(threshold = c(3.491, 5.172))

  t6_6_summary <- t6_6_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t6_6 <- list(
    "dfTransformed" = t6_6_transformed,
    "dfAnalyzed" = t6_6_analyzed,
    "dfFlagged" = t6_6_flagged,
    "dfSummary" = t6_6_summary
  )

  # remove metadata that is not part of qualification
  test6_6$lData$dfConfig <- NULL

  # compare results
  expect_equal(test6_6$lData, t6_6)
})
