test_that("Given appropriate Protocol Deviation data, the assessment function correctly performs a Protocol Deviation Assessment grouped by a custom variable using the Poisson method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Binary()

  test23_3 <- PD_Assess_Binary(
    dfInput = dfInput,
    strMethod = "Poisson",
    strGroup = "CustomGroup"
  )

  # Double Programming
  t23_3_input <- dfInput

  t23_3_transformed <- dfInput %>%
    qualification_transform_counts(
      GroupID = "CustomGroupID",
      exposureCol = "Total"
    )

  t23_3_analyzed <- t23_3_transformed %>%
    qualification_analyze_poisson()

  class(t23_3_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t23_3_flagged <- t23_3_analyzed %>%
    qualification_flag_poisson()

  t23_3_summary <- t23_3_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t23_3 <- list(
    "dfTransformed" = t23_3_transformed,
    "dfAnalyzed" = t23_3_analyzed,
    "dfFlagged" = t23_3_flagged,
    "dfSummary" = t23_3_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test23_3$lData[names(test23_3$lData) != "dfBounds"], t23_3)
})
