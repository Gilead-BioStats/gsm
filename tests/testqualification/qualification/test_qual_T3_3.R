test_that("Given appropriate Inclusion/Exclusion data, the assessment function correctly performs an Inclusion/Exclusion Assessment grouped by a custom variable using the Identity method and correctly assigns Flag variable values.", {
  # # gsm analysis
  # dfInput <- IE_Map_Raw()
  #
  # test3_3 <- IE_Assess(
  #   dfInput = dfInput,
  #   strGroup = "CustomGroup"
  # )
  #
  # # Double Programming
  # t3_3_input <- dfInput
  #
  # t3_3_transformed <- dfInput %>%
  #   qualification_transform_counts(
  #     exposureCol = NA,
  #     GroupID = "CustomGroupID"
  #   )
  #
  # t3_3_analyzed <- t3_3_transformed %>%
  #   mutate(
  #     Score = TotalCount
  #   ) %>%
  #   arrange(Score)
  #
  # class(t3_3_analyzed) <- c("tbl_df", "tbl", "data.frame")
  #
  # t3_3_flagged <- t3_3_analyzed %>%
  #   mutate(
  #     Flag = case_when(
  #       Score > 0.5 ~ 1,
  #       is.na(Score) ~ NA_real_,
  #       is.nan(Score) ~ NA_real_,
  #       TRUE ~ 0
  #     ),
  #   ) %>%
  #   arrange(match(Flag, c(2, -2, 1, -1, 0)))
  #
  # t3_3_summary <- t3_3_flagged %>%
  #   mutate(
  #     Numerator = NA,
  #     Denominator = NA,
  #   ) %>%
  #   select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
  #   arrange(desc(abs(Metric))) %>%
  #   arrange(match(Flag, c(2, -2, 1, -1, 0)))
  #
  # t3_3 <- list(
  #   "dfTransformed" = t3_3_transformed,
  #   "dfAnalyzed" = t3_3_analyzed,
  #   "dfFlagged" = t3_3_flagged,
  #   "dfSummary" = t3_3_summary
  # )
  #
  # # remove metadata that is not part of qualification
  # test3_3$lData$dfConfig <- NULL
  #
  # # compare results
  # expect_equal(test3_3$lData, t3_3)
})
