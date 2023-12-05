test_that("Given an appropriate subset of Protocol Deviation data, the assessment function correctly performs a Protocol Deviation Assessment grouped by a custom variable using the Identity method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Rate(dfs = list(
    dfPD = clindata::ctms_protdev %>% filter(deemedimportant == "Yes"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test2_5 <- PD_Assess_Rate(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "Study"
  )

  # double programming
  t2_5_input <- dfInput

  t2_5_transformed <- dfInput %>%
    qualification_transform_counts(
      GroupID = "StudyID"
    )

  t2_5_analyzed <- t2_5_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t2_5_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t2_5_flagged <- t2_5_analyzed %>%
    qualification_flag_identity()

  t2_5_summary <- t2_5_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t2_5 <- list(
    "dfTransformed" = t2_5_transformed,
    "dfAnalyzed" = t2_5_analyzed,
    "dfFlagged" = t2_5_flagged,
    "dfSummary" = t2_5_summary
  )

  # remove metadata that is not part of qualification
  test2_5$lData$dfConfig <- NULL

  # compare results
  expect_equal(test2_5$lData, t2_5)
})
