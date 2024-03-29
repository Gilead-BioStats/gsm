test_that("Given appropriate Adverse Event data, the assessment function correctly performs an Adverse Event Assessment grouped by a custom variable using the Identity method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Raw()

  test1_6 <- AE_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "CustomGroup"
  )

  # double programming
  t1_6_input <- dfInput

  t1_6_transformed <- dfInput %>%
    qualification_transform_counts(
      GroupID = "CustomGroupID"
    )

  t1_6_analyzed <- t1_6_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t1_6_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t1_6_flagged <- t1_6_analyzed %>%
    qualification_flag_identity(threshold = c(0.00006, 0.01))

  t1_6_summary <- t1_6_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t1_6 <- list(
    "dfTransformed" = t1_6_transformed,
    "dfAnalyzed" = t1_6_analyzed,
    "dfFlagged" = t1_6_flagged,
    "dfSummary" = t1_6_summary
  )

  # remove metadata that is not part of qualification
  test1_6$lData$dfConfig <- NULL

  # compare results
  expect_equal(test1_6$lData, t1_6)
})
