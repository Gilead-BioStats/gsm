test_that("Given appropriate Query Rate data, the assessment function correctly performs a Query Rate Assessment grouped by the Site variable using the Identity method and correctly assigns Flag variable values when given a custom threshold, and Flag variable values are set to NA for sites with low enrollment.", {
  # # gsm analysis
  # dfInput <- gsm::QueryRate_Map_Raw()
  #
  # nMinDenominator <- 196
  #
  # test10_11 <- QueryRate_Assess(
  #   dfInput = dfInput,
  #   strMethod = "Identity",
  #   strGroup = "Site",
  #   vThreshold = c(0.005, 0.05),
  #   nMinDenominator = nMinDenominator
  # )
  #
  # # double programming
  # t10_11_input <- dfInput
  #
  # t10_11_transformed <- dfInput %>%
  #   qualification_transform_counts(
  #     countCol = "Count",
  #     exposureCol = "DataPoint"
  #   )
  #
  # t10_11_analyzed <- t10_11_transformed %>%
  #   mutate(
  #     Score = Metric
  #   ) %>%
  #   arrange(Score)
  #
  # class(t10_11_analyzed) <- c("tbl_df", "tbl", "data.frame")
  #
  # t10_11_flagged <- t10_11_analyzed %>%
  #   qualification_flag_identity(threshold = c(0.005, 0.05))
  #
  # t10_11_summary <- t10_11_flagged %>%
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
  # t10_11 <- list(
  #   "dfTransformed" = t10_11_transformed,
  #   "dfAnalyzed" = t10_11_analyzed,
  #   "dfFlagged" = t10_11_flagged,
  #   "dfSummary" = t10_11_summary
  # )
  #
  # # remove metadata that is not part of qualification
  # test10_11$lData$dfConfig <- NULL
  #
  # # compare results
  # expect_equal(test10_11$lData, t10_11)
})
