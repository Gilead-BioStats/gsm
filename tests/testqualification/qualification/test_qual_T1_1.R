test_that("AE assessment can return a correctly assessed data frame for the poisson test grouped by the site variable when given correct input data from safetyData and the results should be flagged correctly.", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Adam()

  test1_1 <- AE_Assess(
    dfInput = dfInput,
    strMethod = "poisson",
    bChart = FALSE
  )

  # Double Programming
  t1_input <- dfInput

  t1_transformed <- dfInput %>%
    qualification_transform_counts(KRILabel = "AEs/Week")

  t1_analyzed <- t1_transformed %>%
    qualification_analyze_poisson()

  class(t1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t1_flagged <- t1_analyzed %>%
    mutate(
      ThresholdLow = -5,
      ThresholdHigh = 5,
      ThresholdCol = "Score",
      Flag = case_when(
        Score < -5 ~ -1,
        Score > 5 ~ 1,
        is.na(Score) ~ NA_real_,
        is.nan(Score) ~ NA_real_,
        TRUE ~ 0
      ),
    ) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t1_summary <- t1_flagged %>%
    mutate(
      Assessment = "AE"
    ) %>%
    select(GroupID, GroupLabel, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
    arrange(desc(abs(KRI))) %>%
    arrange(match(Flag, c(1, -1, 0)))


  t1_1 <- list(
    "strFunctionName" = "AE_Assess()",
    "lParams" = list(
      "dfInput" = "dfInput",
      "strMethod" = "poisson",
      "bChart" = "FALSE"
    ),
    "lTags" = list(Assessment = "AE"),
    "dfInput" = t1_input,
    "dfTransformed" = t1_transformed,
    "dfAnalyzed" = t1_analyzed,
    "dfFlagged" = t1_flagged,
    "dfSummary" = t1_summary
  )

  # compare results
  expect_equal(test1_1, t1_1)
})
