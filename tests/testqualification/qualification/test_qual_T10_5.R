test_that("Given an appropriate subset of Query Rate data, the assessment function correctly performs a Query Rate Assessment grouped by the Study variable using the Identity method and correctly assigns Flag variable values.", {
  #   # gsm analysis
  #   dfInput <- gsm::QueryRate_Map_Raw(dfs = list(
  #     dfQUERY = clindata::edc_queries %>% filter(visit == "Week 120"),
  #     dfSUBJ = clindata::rawplus_dm,
  #     dfDATACHG = clindata::edc_data_points
  #   ))
  #
  #   test10_5 <- QueryRate_Assess(
  #     dfInput = dfInput,
  #     strMethod = "Identity",
  #     strGroup = "Study"
  #   )
  #
  #   # double programming
  #   t10_5_input <- dfInput
  #
  #   t10_5_transformed <- dfInput %>%
  #     qualification_transform_counts(
  #       countCol = "Count",
  #       exposureCol = "DataPoint",
  #       GroupID = "StudyID"
  #     )
  #
  #   t10_5_analyzed <- t10_5_transformed %>%
  #     mutate(
  #       Score = Metric
  #     ) %>%
  #     arrange(Score)
  #
  #   class(t10_5_analyzed) <- c("tbl_df", "tbl", "data.frame")
  #
  #   t10_5_flagged <- t10_5_analyzed %>%
  #     qualification_flag_identity(threshold = c(0.00006, 0.01))
  #
  #   t10_5_summary <- t10_5_flagged %>%
  #     select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
  #     arrange(desc(abs(Metric))) %>%
  #     arrange(match(Flag, c(2, -2, 1, -1, 0)))
  #
  #
  #   t10_5 <- list(
  #     "dfTransformed" = t10_5_transformed,
  #     "dfAnalyzed" = t10_5_analyzed,
  #     "dfFlagged" = t10_5_flagged,
  #     "dfSummary" = t10_5_summary
  #   )
  #
  #   # remove metadata that is not part of qualification
  #   test10_5$lData$dfConfig <- NULL
  #
  #   # compare results
  #   expect_equal(test10_5$lData, t10_5)
})
