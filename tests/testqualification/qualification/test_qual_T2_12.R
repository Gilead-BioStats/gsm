test_that("Given appropriate Protocol Deviation data, the assessment function correctly performs a Protocol Deviation Assessment grouped by the Site variable using the Normal Approximation method and correctly assigns Flag variable values when given a custom threshold, and Flag variable values are set to NA for sites with low enrollment.", {
  # # gsm analysis
  # dfInput <- gsm::PD_Map_Raw_Rate()
  #
  # nMinDenominator <- 54
  #
  # test2_12 <- PD_Assess_Rate(
  #   dfInput = dfInput,
  #   strMethod = "NormalApprox",
  #   vThreshold = c(-2, -1, 1, 2),
  #   nMinDenominator = nMinDenominator
  # )
  #
  # # Double Programming
  # t2_12_input <- dfInput
  #
  # t2_12_transformed <- dfInput %>%
  #   qualification_transform_counts()
  #
  # t2_12_analyzed <- t2_12_transformed %>%
  #   qualification_analyze_normalapprox(strType = "rate")
  #
  # class(t2_12_analyzed) <- c("tbl_df", "tbl", "data.frame")
  #
  # t2_12_flagged <- t2_12_analyzed %>%
  #   qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))
  #
  # t2_12_summary <- t2_12_flagged %>%
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
  # t2_12 <- list(
  #   "dfTransformed" = t2_12_transformed,
  #   "dfAnalyzed" = t2_12_analyzed,
  #   "dfFlagged" = t2_12_flagged,
  #   "dfSummary" = t2_12_summary
  # )
  #
  # # compare results
  # # remove bounds dataframe for now
  # expect_equal(test2_12$lData[!names(test2_12$lData) %in% c("dfBounds", "dfConfig")], t2_12)
})
