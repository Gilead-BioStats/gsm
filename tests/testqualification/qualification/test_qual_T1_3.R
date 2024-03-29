test_that("Given appropriate Adverse Event data, the assessment function correctly performs an Adverse Event Assessment grouped by a custom variable using the Poisson method and correctly assigns Flag variable values.", {
  # gsm analysis

  dfInput <- gsm::AE_Map_Raw()

  test1_3 <- AE_Assess(
    dfInput = dfInput,
    strMethod = "Poisson",
    strGroup = "CustomGroup"
  )

  # Double Programming
  t1_3_input <- dfInput

  t1_3_transformed <- dfInput %>%
    qualification_transform_counts(
      GroupID = "CustomGroupID"
    )

  t1_3_analyzed <- t1_3_transformed %>%
    qualification_analyze_poisson()

  class(t1_3_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t1_3_flagged <- t1_3_analyzed %>%
    qualification_flag_poisson()

  t1_3_summary <- t1_3_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t1_3 <- list(
    "dfTransformed" = t1_3_transformed,
    "dfAnalyzed" = t1_3_analyzed,
    "dfFlagged" = t1_3_flagged,
    "dfSummary" = t1_3_summary
  )

  # remove metadata that is not part of qualification
  test1_3$lData$dfConfig <- NULL

  # compare results
  # remove bounds dataframe for now
  expect_equal(test1_3$lData[names(test1_3$lData) != "dfBounds"], t1_3)
})
