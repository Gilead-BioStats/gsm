test_that("AE assessment can return a correctly assessed data frame for the wilcoxon test grouped by the site variable when given correct input data from safetyData and the results should be flagged correctly.", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Adam()

  test1_5 <- AE_Assess(
    dfInput = dfInput,
    strMethod = "wilcoxon",
    bChart = FALSE
  )

  # double programming
  t1_5_input <- dfInput

  t1_5_transformed <- dfInput %>%
    qualification_transform_counts(KRILabel = "AEs/Week")

  t1_5_analyzed <- t1_5_transformed %>%
    qualification_analyze_wilcoxon()

  class(t1_5_analyzed) <- c("tbl_df", "tbl", "data.frame")
  names(t1_5_analyzed$Estimate) <- rep("difference in location", nrow(t1_5_analyzed))

  t1_5_flagged <- t1_5_analyzed %>%
    mutate(
      ThresholdLow = .0001,
      ThresholdHigh = NA_integer_,
      ThresholdCol = "Score",
      Flag = case_when(
        Score < 0.0001 ~ -1,
        is.na(Score) ~ NA_real_,
        is.nan(Score) ~ NA_real_,
        TRUE ~ 0
      ),
      median = median(Estimate),
      Flag = case_when(
        Flag != 0 & Estimate < median ~ -1,
        Flag != 0 & Estimate >= median ~ 1,
        TRUE ~ Flag
      )
    ) %>%
    select(-median) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t1_5_summary <- t1_5_flagged %>%
    mutate(
      Assessment = "AE"
    ) %>%
    select(GroupID, GroupLabel, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
    arrange(desc(abs(KRI))) %>%
    arrange(match(Flag, c(1, -1, 0)))


  t1_5 <- list(
    "strFunctionName" = "AE_Assess()",
    "lTags" = list(Assessment = "AE"),
    "dfInput" = t1_5_input,
    "dfTransformed" = t1_5_transformed,
    "dfAnalyzed" = t1_5_analyzed,
    "dfFlagged" = t1_5_flagged,
    "dfSummary" = t1_5_summary
  )

  # compare results
  expect_equal(test1_5, t1_5)
})
