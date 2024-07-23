test_that("Given an appropriate subset of Data Entry Lag data, the assessment function correctly performs a Data Entry Lag Assessment grouped by the Site variable using the Identity method and correctly assigns Flag variable values when given a custom threshold.", {
  #   # gsm analysis
  #   dfInput <- gsm::DataEntry_Map_Raw(dfs = list(
  #     dfDATAENT = clindata::edc_data_pages %>% filter(visit == "Week 120"),
  #     dfSUBJ = clindata::rawplus_dm
  #   ))
  #
  #   test8_4 <- DataEntry_Assess(
  #     dfInput = dfInput,
  #     strMethod = "Identity",
  #     strGroup = "Site",
  #     vThreshold = c(0.00006, 0.01)
  #   )
  #
  #   # double programming
  #   t8_4_input <- dfInput
  #
  #   t8_4_transformed <- dfInput %>%
  #     qualification_transform_counts(
  #       countCol = "Count",
  #       exposureCol = "Total"
  #     )
  #
  #   t8_4_analyzed <- t8_4_transformed %>%
  #     mutate(
  #       Score = Metric
  #     ) %>%
  #     arrange(Score)
  #
  #   class(t8_4_analyzed) <- c("tbl_df", "tbl", "data.frame")
  #
  #   t8_4_flagged <- t8_4_analyzed %>%
  #     qualification_flag_identity(threshold = c(0.00006, 0.01))
  #
  #   t8_4_summary <- t8_4_flagged %>%
  #     select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
  #     arrange(desc(abs(Metric))) %>%
  #     arrange(match(Flag, c(2, -2, 1, -1, 0)))
  #
  #
  #   t8_4 <- list(
  #     "dfTransformed" = t8_4_transformed,
  #     "dfAnalyzed" = t8_4_analyzed,
  #     "dfFlagged" = t8_4_flagged,
  #     "dfSummary" = t8_4_summary
  #   )
  #
  #   # remove metadata that is not part of qualification
  #   test8_4$lData$dfConfig <- NULL
  #
  #   # compare results
  #   expect_equal(test8_4$lData, t8_4)
})
