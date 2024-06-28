test_that("Given appropriate Query Rate data, the assessment function correctly performs a Query Rate Assessment grouped by a custom variable using the Poisson method and correctly assigns Flag variable values.", {
  # # gsm analysis
  # dfInput <- gsm::QueryRate_Map_Raw()
  #
  # test10_3 <- QueryRate_Assess(
  #   dfInput = dfInput,
  #   strMethod = "Poisson",
  #   strGroup = "CustomGroup"
  # )
  #
  # # double programming
  # t10_3_input <- dfInput
  #
  # t10_3_transformed <- dfInput %>%
  #   qualification_transform_counts(
  #     countCol = "Count",
  #     exposureCol = "DataPoint",
  #     GroupID = "CustomGroupID"
  #   )
  #
  # t10_3_analyzed <- t10_3_transformed %>%
  #   qualification_analyze_poisson()
  #
  # class(t10_3_analyzed) <- c("tbl_df", "tbl", "data.frame")
  #
  #
  # t10_3_flagged <- t10_3_analyzed %>%
  #   qualification_flag_poisson()
  #
  # t10_3_summary <- t10_3_flagged %>%
  #   select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
  #   arrange(desc(abs(Metric))) %>%
  #   arrange(match(Flag, c(2, -2, 1, -1, 0)))
  #
  #
  # t10_3 <- list(
  #   "dfTransformed" = t10_3_transformed,
  #   "dfAnalyzed" = t10_3_analyzed,
  #   "dfFlagged" = t10_3_flagged,
  #   "dfSummary" = t10_3_summary
  # )
  #
  # # compare results
  # expect_equal(test10_3$lData[!names(test10_3$lData) %in% c("dfBounds", "dfConfig")], t10_3)
})
