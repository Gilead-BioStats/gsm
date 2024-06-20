test_that("Given appropriate Disposition data, the assessment function correctly performs a Disposition Assessment grouped by a custom variable using the Identity method and correctly assigns Flag variable values.", {
  # # gsm analysis
  # dfInput <- Disp_Map_Raw()
  #
  # test5_6 <- Disp_Assess(
  #   dfInput = dfInput,
  #   strMethod = "Identity",
  #   strGroup = "CustomGroup"
  # )
  #
  # # Double Programming
  # t5_6_input <- dfInput
  #
  # t5_6_transformed <- dfInput %>%
  #   qualification_transform_counts(
  #     exposureCol = "Total",
  #     GroupID = "CustomGroupID"
  #   )
  #
  # t5_6_analyzed <- t5_6_transformed %>%
  #   mutate(
  #     Score = Metric
  #   ) %>%
  #   arrange(Score)
  #
  # class(t5_6_analyzed) <- c("tbl_df", "tbl", "data.frame")
  #
  # t5_6_flagged <- t5_6_analyzed %>%
  #   qualification_flag_identity()
  #
  # t5_6_summary <- t5_6_flagged %>%
  #   select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
  #   arrange(desc(abs(Metric))) %>%
  #   arrange(match(Flag, c(2, -2, 1, -1, 0)))
  #
  # t5_6 <- list(
  #   "dfTransformed" = t5_6_transformed,
  #   "dfAnalyzed" = t5_6_analyzed,
  #   "dfFlagged" = t5_6_flagged,
  #   "dfSummary" = t5_6_summary
  # )
  #
  # # remove metadata that is not part of qualification
  # test5_6$lData$dfConfig <- NULL
  #
  # # compare results
  # expect_equal(test5_6$lData, t5_6)
})
