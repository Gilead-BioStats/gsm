test_that("Given appropriate Protocol Deviation data, the assessment function correctly performs a Protocol Deviation Assessment grouped by the Site variable using the Identity method and correctly assigns Flag variable values.", {
  # # gsm analysis
  # dfInput <- gsm::PD_Map_Raw_Rate()
  #
  # test2_6 <- PD_Assess_Rate(
  #   dfInput = dfInput,
  #   strMethod = "Identity",
  #   strGroup = "CustomGroup"
  # )
  #
  # # double programming
  # t2_6_input <- dfInput
  #
  # t2_6_transformed <- dfInput %>%
  #   qualification_transform_counts(
  #     GroupID = "CustomGroupID"
  #   )
  #
  # t2_6_analyzed <- t2_6_transformed %>%
  #   mutate(
  #     Score = Metric
  #   ) %>%
  #   arrange(Score)
  #
  # class(t2_6_analyzed) <- c("tbl_df", "tbl", "data.frame")
  #
  # t2_6_flagged <- t2_6_analyzed %>%
  #   qualification_flag_identity()
  #
  # t2_6_summary <- t2_6_flagged %>%
  #   select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
  #   arrange(desc(abs(Metric))) %>%
  #   arrange(match(Flag, c(2, -2, 1, -1, 0)))
  #
  # t2_6 <- list(
  #   "dfTransformed" = t2_6_transformed,
  #   "dfAnalyzed" = t2_6_analyzed,
  #   "dfFlagged" = t2_6_flagged,
  #   "dfSummary" = t2_6_summary
  # )
  #
  # # remove metadata that is not part of qualification
  # test2_6$lData$dfConfig <- NULL
  #
  # # compare results
  # expect_equal(test2_6$lData, t2_6)
})
