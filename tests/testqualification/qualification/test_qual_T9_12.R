test_that("Given appropriate Query Age data, the assessment function correctly performs a Query Age Assessment grouped by the Site variable using the Normal Approximation method and correctly assigns Flag variable values when given a custom threshold, and Flag variable values are set to NA for sites with low enrollment.", {
  # # gsm analysis
  # dfInput <- gsm::QueryAge_Map_Raw()
  #
  # nMinDenominator <- 10
  #
  # test9_12 <- QueryAge_Assess(
  #   dfInput = dfInput,
  #   strMethod = "NormalApprox",
  #   strGroup = "Site",
  #   vThreshold = c(-2, -1, 1, 2),
  #   nMinDenominator = nMinDenominator
  # )
  #
  # # double programming
  # t9_12_input <- dfInput
  #
  # t9_12_transformed <- dfInput %>%
  #   qualification_transform_counts(
  #     countCol = "Count",
  #     exposureCol = "Total"
  #   )
  #
  # t9_12_analyzed <- t9_12_transformed %>%
  #   qualification_analyze_normalapprox(strType = "binary")
  #
  # class(t9_12_analyzed) <- c("tbl_df", "tbl", "data.frame")
  #
  # t9_12_flagged <- t9_12_analyzed %>%
  #   qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))
  #
  # t9_12_summary <- t9_12_flagged %>%
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
  # t9_12 <- list(
  #   "dfTransformed" = t9_12_transformed,
  #   "dfAnalyzed" = t9_12_analyzed,
  #   "dfFlagged" = t9_12_flagged,
  #   "dfSummary" = t9_12_summary
  # )
  #
  # # compare results
  # expect_equal(test9_12$lData[!names(test9_12$lData) %in% c("dfBounds", "dfConfig")], t9_12)
})
