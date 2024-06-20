test_that("Given appropriate Labs data, the assessment function correctly performs a Labs Assessment grouped by a custom variable using the Normal Approximation method and correctly assigns Flag variable values.", {
  # # gsm analysis
  # dfInput <- gsm::LB_Map_Raw()
  #
  # test6_9 <- LB_Assess(
  #   dfInput = dfInput,
  #   strGroup = "CustomGroup",
  #   strMethod = "NormalApprox"
  # )
  #
  # # Double Programming
  # t6_9_input <- dfInput
  #
  # t6_9_transformed <- dfInput %>%
  #   qualification_transform_counts(
  #     exposureCol = "Total",
  #     GroupID = "CustomGroupID"
  #   )
  #
  # t6_9_analyzed <- t6_9_transformed %>%
  #   qualification_analyze_normalapprox(strType = "binary")
  #
  # class(t6_9_analyzed) <- c("tbl_df", "tbl", "data.frame")
  #
  # t6_9_flagged <- t6_9_analyzed %>%
  #   qualification_flag_normalapprox()
  #
  # t6_9_summary <- t6_9_flagged %>%
  #   select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
  #   arrange(desc(abs(Metric))) %>%
  #   arrange(match(Flag, c(2, -2, 1, -1, 0)))
  #
  # t6_9 <- list(
  #   "dfTransformed" = t6_9_transformed,
  #   "dfAnalyzed" = t6_9_analyzed,
  #   "dfFlagged" = t6_9_flagged,
  #   "dfSummary" = t6_9_summary
  # )
  #
  # # compare results
  # expect_equal(test6_9$lData[!names(test6_9$lData) %in% c("dfBounds", "dfConfig")], t6_9)
})
