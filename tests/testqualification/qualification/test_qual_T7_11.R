test_that("Given appropriate Data Change Rate data, the assessment function correctly performs a Data Change Rate Assessment grouped by the Site variable using the Identity method and correctly assigns Flag variable values when given a custom threshold, and Flag variable values are set to NA for sites with low enrollment.", {
  # # gsm analysis
  # dfInput <- gsm::DataChg_Map_Raw()
  #
  # nMinDenominator <- 197
  #
  # test7_11 <- DataChg_Assess(
  #   dfInput = dfInput,
  #   strMethod = "Identity",
  #   strGroup = "Site",
  #   vThreshold = c(0.00006, 0.01),
  #   nMinDenominator = nMinDenominator
  # )
  #
  # # double programming
  # t7_11_input <- dfInput
  #
  # t7_11_transformed <- dfInput %>%
  #   qualification_transform_counts(
  #     countCol = "Count",
  #     exposureCol = "Total"
  #   )
  #
  # t7_11_analyzed <- t7_11_transformed %>%
  #   mutate(
  #     Score = Metric
  #   ) %>%
  #   arrange(Score)
  #
  # class(t7_11_analyzed) <- c("tbl_df", "tbl", "data.frame")
  #
  # t7_11_flagged <- t7_11_analyzed %>%
  #   qualification_flag_identity(threshold = c(0.00006, 0.01))
  #
  # t7_11_summary <- t7_11_flagged %>%
  #   select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
  #   arrange(desc(abs(Metric))) %>%
  #   arrange(match(Flag, c(2, -2, 1, -1, 0))) %>%
  #   mutate(
  #     Score = case_when(
  #       Denominator >= nMinDenominator ~ Score,
  #       Denominator < nMinDenominator ~ NA_real_
  #     ),
  #     Flag = case_when(
  #       Denominator >= nMinDenominator ~ Flag,
  #       Denominator < nMinDenominator ~ NA_real_
  #     )
  #   )
  #
  #
  # t7_11 <- list(
  #   "dfTransformed" = t7_11_transformed,
  #   "dfAnalyzed" = t7_11_analyzed,
  #   "dfFlagged" = t7_11_flagged,
  #   "dfSummary" = t7_11_summary
  # )
  #
  # # remove metadata that is not part of qualification
  # test7_11$lData$dfConfig <- NULL
  #
  # # compare results
  # expect_equal(test7_11$lData, t7_11)
})
