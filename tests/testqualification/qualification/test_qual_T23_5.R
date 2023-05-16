test_that("Given an appropriate subset of Protocol Deviation data, the assessment function correctly performs a Protocol Deviation Assessment grouped by a custom variable using the Identity method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Binary(dfs = list(
    dfPD = clindata::ctms_protdev %>% filter(deemedimportant == "Yes"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test23_5 <- PD_Assess_Binary(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "Study"
  )

  # double programming
  t23_5_input <- dfInput

  t23_5_transformed <- dfInput %>%
    qualification_transform_counts(
      GroupID = "StudyID",
      exposureCol = "Total"
    )

  t23_5_analyzed <- t23_5_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t23_5_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t23_5_flagged <- t23_5_analyzed %>%
    qualification_flag_identity()

  t23_5_summary <- t23_5_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t23_5 <- list(
    "dfTransformed" = t23_5_transformed,
    "dfAnalyzed" = t23_5_analyzed,
    "dfFlagged" = t23_5_flagged,
    "dfSummary" = t23_5_summary
  )

  # compare results
  expect_equal(test23_5$lData, t23_5)
})
