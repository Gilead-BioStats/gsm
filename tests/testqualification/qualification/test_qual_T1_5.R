test_that("Given an appropriate subset of Adverse Event data, the assessment function correctly performs an Adverse Event Assessment grouped by the Study variable using the Identity method and correctly assigns Flag variable values.", {
  # gsm analysis
  # dfInput <- gsm::AE_Map_Raw(dfs = list(
  #   dfAE = clindata::rawplus_ae %>% filter(aeser_std_nsv == "Y"),
  #   dfSUBJ = clindata::rawplus_dm
  # ))
  #
  # test1_5 <- AE_Assess(
  #   dfInput = dfInput,
  #   strMethod = "Identity",
  #   strGroup = "Study"
  # )
  #
  # # double programming
  # t1_5_input <- dfInput
  #
  # t1_5_transformed <- dfInput %>%
  #   qualification_transform_counts(
  #     GroupID = "StudyID"
  #   )
  #
  # t1_5_analyzed <- t1_5_transformed %>%
  #   mutate(
  #     Score = Metric
  #   ) %>%
  #   arrange(Score)
  #
  # class(t1_5_analyzed) <- c("tbl_df", "tbl", "data.frame")
  #
  # t1_5_flagged <- t1_5_analyzed %>%
  #   qualification_flag_identity(threshold = c(0.00006, 0.01))
  #
  # t1_5_summary <- t1_5_flagged %>%
  #   select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
  #   arrange(desc(abs(Metric))) %>%
  #   arrange(match(Flag, c(2, -2, 1, -1, 0)))
  #
  # t1_5 <- list(
  #   "dfTransformed" = t1_5_transformed,
  #   "dfAnalyzed" = t1_5_analyzed,
  #   "dfFlagged" = t1_5_flagged,
  #   "dfSummary" = t1_5_summary
  # )
  #
  # # remove metadata that is not part of qualification
  # test1_5$lData$dfConfig <- NULL
  #
  # # compare results
  # expect_equal(test1_5$lData, t1_5)
})
