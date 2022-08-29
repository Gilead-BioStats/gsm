test_that("PD assessment can return a correctly assessed data frame for the poisson test grouped by the site variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw()

  test2_1 <- PD_Assess(
    dfInput = dfInput,
    strMethod = "poisson",
    vThreshold = c(-3, 3),
    bChart = FALSE
  )

  # Double Programming
  t2_1_input <- dfInput

  t2_1_transformed <- dfInput %>%
    qualification_transform_counts(KRILabel = "PDs/Week")

  t2_1_analyzed <- t2_1_transformed %>%
    qualification_analyze_poisson()

  class(t2_1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t2_1_flagged <- t2_1_analyzed %>%
    mutate(
      ThresholdLow = -3,
      ThresholdHigh = 3,
      ThresholdCol = "Score",
      Flag = case_when(
        Score < -3 ~ -1,
        Score > 3 ~ 1,
        is.na(Score) ~ NA_real_,
        is.nan(Score) ~ NA_real_,
        TRUE ~ 0
      ),
    ) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t2_1_summary <- t2_1_flagged %>%
    mutate(
      Assessment = "PD"
    ) %>%
    select(GroupID, GroupLabel, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
    arrange(desc(abs(KRI))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t2_1 <- list(
    "strFunctionName" = "PD_Assess()",
    "lTags" = list(Assessment = "PD"),
    "dfInput" = t2_1_input,
    "dfTransformed" = t2_1_transformed,
    "dfAnalyzed" = t2_1_analyzed,
    "dfFlagged" = t2_1_flagged,
    "dfSummary" = t2_1_summary
  )

  # compare results
  expect_equal(test2_1, t2_1)
})
