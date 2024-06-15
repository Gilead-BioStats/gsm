test_that("Given an appropriate subset of Inclusion/Exclusion data, the assessment function correctly performs an Inclusion/Exclusion Assessment grouped by the Study variable using the Identity method and correctly assigns Flag variable values when given a custom threshold.", {
  # # gsm analysis
  # dfInput <- IE_Map_Raw(dfs = list(
  #   dfSUBJ = clindata::rawplus_dm %>% filter(!siteid %in% c("5", "29", "58")),
  #   dfIE = clindata::rawplus_ie
  # ))
  #
  # test3_2 <- IE_Assess(
  #   dfInput = dfInput,
  #   nThreshold = 1.5,
  #   strGroup = "Study"
  # )
  #
  # # Double Programming
  # t3_2_input <- dfInput
  #
  # t3_2_transformed <- dfInput %>%
  #   qualification_transform_counts(
  #     exposureCol = NA,
  #     GroupID = "StudyID"
  #   )
  #
  # t3_2_analyzed <- t3_2_transformed %>%
  #   mutate(
  #     Score = TotalCount
  #   ) %>%
  #   arrange(Score)
  #
  # class(t3_2_analyzed) <- c("tbl_df", "tbl", "data.frame")
  #
  # t3_2_flagged <- t3_2_analyzed %>%
  #   mutate(
  #     Flag = case_when(
  #       Score > 1.5 ~ 1,
  #       is.na(Score) ~ NA_real_,
  #       is.nan(Score) ~ NA_real_,
  #       TRUE ~ 0
  #     ),
  #   ) %>%
  #   arrange(match(Flag, c(2, -2, 1, -1, 0)))
  #
  # t3_2_summary <- t3_2_flagged %>%
  #   mutate(
  #     Numerator = NA,
  #     Denominator = NA,
  #   ) %>%
  #   select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
  #   arrange(desc(abs(Metric))) %>%
  #   arrange(match(Flag, c(2, -2, 1, -1, 0)))
  #
  # t3_2 <- list(
  #   "dfTransformed" = t3_2_transformed,
  #   "dfAnalyzed" = t3_2_analyzed,
  #   "dfFlagged" = t3_2_flagged,
  #   "dfSummary" = t3_2_summary
  # )
  #
  # # remove metadata that is not part of qualification
  # test3_2$lData$dfConfig <- NULL
  #
  # # compare results
  # expect_equal(test3_2$lData, t3_2)
})
