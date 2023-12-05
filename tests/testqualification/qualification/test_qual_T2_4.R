test_that("Given an appropriate subset of Protocol Deviation data, the assessment function correctly performs a Protocol Deviation Assessment grouped by the Site variable using the Identity method and correctly assigns Flag variable values when given a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Rate(dfs = list(
    dfPD = clindata::ctms_protdev %>% filter(deemedimportant == "Yes"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test2_4 <- PD_Assess_Rate(
    dfInput = dfInput,
    strMethod = "Identity",
    vThreshold = c(0.00001, 0.1)
  )

  # double programming
  t2_4_input <- dfInput

  t2_4_transformed <- dfInput %>%
    qualification_transform_counts()

  t2_4_analyzed <- t2_4_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t2_4_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t2_4_flagged <- t2_4_analyzed %>%
    qualification_flag_identity(threshold = c(0.00001, 0.1))

  t2_4_summary <- t2_4_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t2_4 <- list(
    "dfTransformed" = t2_4_transformed,
    "dfAnalyzed" = t2_4_analyzed,
    "dfFlagged" = t2_4_flagged,
    "dfSummary" = t2_4_summary
  )

  # remove metadata that is not part of qualification
  test2_4$lData$dfConfig <- NULL

  # compare results
  expect_equal(test2_4$lData, t2_4)
})
