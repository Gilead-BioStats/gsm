test_that("Given an appropriate subset of Data Entry Lag data, the assessment function correctly performs a Data Entry Lag Assessment grouped by the Study variable using the Identity method and correctly assigns Flag variable values.", {
  # # gsm analysis
  # dfInput <- gsm::DataEntry_Map_Raw(dfs = list(
  #   dfDATAENT = clindata::edc_data_pages %>% filter(visit == "Week 120"),
  #   dfSUBJ = clindata::rawplus_dm
  # ))
  #
  # test8_5 <- DataEntry_Assess(
  #   dfInput = dfInput,
  #   strMethod = "Identity",
  #   strGroup = "Study"
  # )
  #
  # # double programming
  # t8_5_input <- dfInput
  #
  # t8_5_transformed <- dfInput %>%
  #   qualification_transform_counts(
  #     countCol = "Count",
  #     exposureCol = "Total",
  #     GroupID = "StudyID"
  #   )
  #
  # t8_5_analyzed <- t8_5_transformed %>%
  #   mutate(
  #     Score = Metric
  #   ) %>%
  #   arrange(Score)
  #
  # class(t8_5_analyzed) <- c("tbl_df", "tbl", "data.frame")
  #
  # t8_5_flagged <- t8_5_analyzed %>%
  #   qualification_flag_identity()
  #
  # t8_5_summary <- t8_5_flagged %>%
  #   select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
  #   arrange(desc(abs(Metric))) %>%
  #   arrange(match(Flag, c(2, -2, 1, -1, 0)))
  #
  #
  # t8_5 <- list(
  #   "dfTransformed" = t8_5_transformed,
  #   "dfAnalyzed" = t8_5_analyzed,
  #   "dfFlagged" = t8_5_flagged,
  #   "dfSummary" = t8_5_summary
  # )
  #
  # # remove metadata that is not part of qualification
  # test8_5$lData$dfConfig <- NULL
  #
  # # compare results
  # expect_equal(test8_5$lData, t8_5)
})
