test_that("Given an appropriate subset of Disposition data, the assessment function correctly performs a Disposition Assessment grouped by the Study variable using the Identity method and correctly assigns Flag variable values.", {
  # # gsm analysis
  # dfInput <- gsm::Disp_Map_Raw(dfs = list(
  #   dfSUBJ = clindata::rawplus_dm,
  #   dfSTUDCOMP = clindata::rawplus_studcomp %>% filter(compreas_std_nsv == "ID"),
  #   dfSDRGCOMP = clindata::rawplus_sdrgcomp %>% filter(datapagename ==
  #     "Blinded Study Drug Completion")
  # ))
  #
  # test5_5 <- Disp_Assess(
  #   dfInput = dfInput,
  #   strMethod = "Identity",
  #   strGroup = "Study"
  # )
  #
  # # Double Programming
  # t5_5_input <- dfInput
  #
  # t5_5_transformed <- dfInput %>%
  #   qualification_transform_counts(
  #     exposureCol = "Total",
  #     GroupID = "StudyID"
  #   )
  #
  # t5_5_analyzed <- t5_5_transformed %>%
  #   mutate(
  #     Score = Metric
  #   ) %>%
  #   arrange(Score)
  #
  # class(t5_5_analyzed) <- c("tbl_df", "tbl", "data.frame")
  #
  # t5_5_flagged <- t5_5_analyzed %>%
  #   qualification_flag_identity()
  #
  # t5_5_summary <- t5_5_flagged %>%
  #   select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
  #   arrange(desc(abs(Metric))) %>%
  #   arrange(match(Flag, c(2, -2, 1, -1, 0)))
  #
  # t5_5 <- list(
  #   "dfTransformed" = t5_5_transformed,
  #   "dfAnalyzed" = t5_5_analyzed,
  #   "dfFlagged" = t5_5_flagged,
  #   "dfSummary" = t5_5_summary
  # )
  #
  # # remove metadata that is not part of qualification
  # test5_5$lData$dfConfig <- NULL
  #
  # # compare results
  # expect_equal(test5_5$lData, t5_5)
})
