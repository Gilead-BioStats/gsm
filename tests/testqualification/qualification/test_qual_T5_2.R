test_that("Given an appropriate subset of Disposition data, the assessment function correctly performs a Disposition Assessment grouped by the Country variable using the Fisher method and correctly assigns Flag variable values.", {
  # # gsm analysis
  # dfInput <- gsm::Disp_Map_Raw(dfs = list(
  #   dfSUBJ = clindata::rawplus_dm,
  #   dfSTUDCOMP = clindata::rawplus_studcomp %>% filter(compreas_std_nsv == "ID"),
  #   dfSDRGCOMP = clindata::rawplus_sdrgcomp %>% filter(datapagename ==
  #     "Blinded Study Drug Completion")
  # ))
  #
  # test5_1 <- Disp_Assess(
  #   dfInput = dfInput,
  #   strGroup = "Country",
  #   strMethod = "Fisher"
  # )
  #
  # # Double Programming
  # t5_1_input <- dfInput
  #
  # t5_1_transformed <- dfInput %>%
  #   qualification_transform_counts(
  #     exposureCol = "Total",
  #     GroupID = "CountryID"
  #   )
  #
  # t5_1_analyzed <- t5_1_transformed %>%
  #   qualification_analyze_fisher()
  #
  # class(t5_1_analyzed) <- c("tbl_df", "tbl", "data.frame")
  #
  # t5_1_flagged <- t5_1_analyzed %>%
  #   qualification_flag_fisher()
  #
  # t5_1_summary <- t5_1_flagged %>%
  #   select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
  #   arrange(desc(abs(Metric))) %>%
  #   arrange(match(Flag, c(2, -2, 1, -1, 0)))
  #
  # t5_1 <- list(
  #   "dfTransformed" = t5_1_transformed,
  #   "dfAnalyzed" = t5_1_analyzed,
  #   "dfFlagged" = t5_1_flagged,
  #   "dfSummary" = t5_1_summary
  # )
  #
  # # remove metadata that is not part of qualification
  # test5_1$lData$dfConfig <- NULL
  #
  # # compare results
  # expect_equal(test5_1$lData, t5_1)
})
