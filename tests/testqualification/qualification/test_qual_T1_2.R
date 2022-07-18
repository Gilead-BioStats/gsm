test_that("AE assessment can return a correctly assessed data frame for the poisson test grouped by the study variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Raw()


  test1_2 <- AE_Assess(
    dfInput = dfInput,
    strMethod = "poisson",
    vThreshold = c(-3, 3),
    bChart = FALSE
  )

  # Double Programming
  t1_2_input <- dfInput

  t1_2_transformed <- dfInput %>%
    qualification_transform_counts(KRILabel = "AEs/Week")

  t1_2_analyzed <- t1_2_transformed %>%
    qualification_analyze_poisson()

  class(t1_2_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t1_2_flagged <- t1_2_analyzed %>%
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

  t1_2_summary <- t1_2_flagged %>%
    mutate(
      Assessment = "AE"
    ) %>%
    select(SiteID, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
    arrange(desc(abs(KRI))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t1_2 <- list(
    "strFunctionName" = "AE_Assess()",
    "lParams" = list(
      "dfInput" = "dfInput",
      "vThreshold" = c("c", "-3", "3"),
      "strMethod" = "poisson",
      "bChart" = "FALSE"
    ),
    "lTags" = list(Assessment = "AE"),
    "dfInput" = t1_2_input,
    "dfTransformed" = t1_2_transformed,
    "dfAnalyzed" = t1_2_analyzed,
    "dfFlagged" = t1_2_flagged,
    "dfSummary" = t1_2_summary
  )

  # compare results
  expect_equal(test1_2, t1_2)
})
