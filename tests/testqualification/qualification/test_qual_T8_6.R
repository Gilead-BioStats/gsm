test_that("Given appropriate Data Entry Lag data, the assessment function correctly performs a Data Entry Lag Assessment grouped by a custom variable using the Identity method and correctly assigns Flag variable values.", {
  # # gsm analysis
  # dfInput <- gsm::DataEntry_Map_Raw()
  #
  # test8_6 <- DataEntry_Assess(
  #   dfInput = dfInput,
  #   strMethod = "Identity",
  #   strGroup = "CustomGroup"
  # )
  #
  # # double programming
  # t8_6_input <- dfInput
  #
  # t8_6_transformed <- dfInput %>%
  #   qualification_transform_counts(
  #     countCol = "Count",
  #     exposureCol = "Total",
  #     GroupID = "CustomGroupID"
  #   )
  #
  # t8_6_analyzed <- t8_6_transformed %>%
  #   mutate(
  #     Score = Metric
  #   ) %>%
  #   arrange(Score)
  #
  # class(t8_6_analyzed) <- c("tbl_df", "tbl", "data.frame")
  #
  #
  # t8_6_flagged <- t8_6_analyzed %>%
  #   qualification_flag_identity()
  #
  # t8_6_summary <- t8_6_flagged %>%
  #   select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
  #   arrange(desc(abs(Metric))) %>%
  #   arrange(match(Flag, c(2, -2, 1, -1, 0)))
  #
  #
  # t8_6 <- list(
  #   "dfTransformed" = t8_6_transformed,
  #   "dfAnalyzed" = t8_6_analyzed,
  #   "dfFlagged" = t8_6_flagged,
  #   "dfSummary" = t8_6_summary
  # )
  #
  # # remove metadata that is not part of qualification
  # test8_6$lData$dfConfig <- NULL
  #
  # # compare results
  # expect_equal(test8_6$lData, t8_6)
})
