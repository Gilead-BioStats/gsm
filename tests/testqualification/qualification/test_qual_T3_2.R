test_that("IE assessment can return a correctly assessed data frame grouped by a custom variable when given subset input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- IE_Map_Raw()

  test3_1 <- IE_Assess(
    dfInput = dfInput,
    strGroup = "Study",
    bChart = FALSE
  )

  # Double Programming
  t3_1_input <- dfInput

  t3_1_transformed <- dfInput %>%
    qualification_transform_counts(exposureCol = NA,
                                   KRILabel = "# of Inclusion/Exclusion Issues",
                                   GroupLabel = "StudyID")

  t3_1_analyzed <- t3_1_transformed %>%
    mutate(
      Score = TotalCount,
      ScoreLabel = "# of Inclusion/Exclusion Issues"
    )

  class(t3_1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t3_1_flagged <- t3_1_analyzed %>%
    mutate(
      ThresholdLow = NA_real_,
      ThresholdHigh = 0.5,
      ThresholdCol = "Score",
      Flag = case_when(
        Score > 0.5 ~ 1,
        is.na(Score) ~ NA_real_,
        is.nan(Score) ~ NA_real_,
        TRUE ~ 0
      ),
    ) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t3_1_summary <- t3_1_flagged %>%
    mutate(
      Assessment = "IE"
    ) %>%
    select(GroupID, GroupLabel, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
    arrange(desc(abs(KRI))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t3_1 <- list(
    "strFunctionName" = "IE_Assess()",
    "lParams" = list(
      "dfInput" = "dfInput",
      "strGroup" = "Study",
      "bChart" = "FALSE"
    ),
    "lTags" = list(Assessment = "IE"),
    "dfInput" = t3_1_input,
    "dfTransformed" = t3_1_transformed,
    "dfAnalyzed" = t3_1_analyzed,
    "dfFlagged" = t3_1_flagged,
    "dfSummary" = t3_1_summary
  )

  # compare results
  expect_equal(test3_1, t3_1)
})
