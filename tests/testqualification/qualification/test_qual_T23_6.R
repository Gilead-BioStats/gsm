test_that("Given appropriate Protocol Deviation data, the assessment function correctly performs a Protocol Deviation Assessment grouped by the Site variable using the Identity method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Binary()

  test23_6 <- PD_Assess_Binary(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "CustomGroup"
  )

  # double programming
  t23_6_input <- dfInput

  t23_6_transformed <- dfInput %>%
    qualification_transform_counts(
      GroupID = "CustomGroupID",
      exposureCol = "Total"
    )

  t23_6_analyzed <- t23_6_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t23_6_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t23_6_flagged <- t23_6_analyzed %>%
    qualification_flag_identity()

  t23_6_summary <- t23_6_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t23_6 <- list(
    "dfTransformed" = t23_6_transformed,
    "dfAnalyzed" = t23_6_analyzed,
    "dfFlagged" = t23_6_flagged,
    "dfSummary" = t23_6_summary
  )

  # compare results
  expect_equal(test23_6$lData, t23_6)
})
