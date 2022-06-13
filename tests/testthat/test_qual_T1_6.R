test_that("AE assessment can return a correctly assessed data frame for the wilcoxon test grouped by the study variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Raw()

  test1_6 <- AE_Assess(
    dfInput = dfInput,
    strMethod = "wilcoxon",
    vThreshold = c(0.1, NA),
    bChart = FALSE
  )

  # double programming
  t1_6_input <- dfInput

  t1_6_transformed <- dfInput %>%
    qualification_transform_counts(KRILabel = "AEs/Week")

  t1_6_analyzed <- t1_6_transformed %>%
    qualification_analyze_wilcoxon()

  class(t1_6_analyzed) <- c("tbl_df", "tbl", "data.frame")
  names(t1_6_analyzed$Estimate) <- rep("difference in location", nrow(t1_6_analyzed))

  t1_6_flagged <- t1_6_analyzed %>%
    mutate(
      ThresholdLow = 0.1,
      ThresholdHigh = NA_integer_,
      ThresholdCol = "Score",
      Flag = case_when(
        Score < 0.1 ~ -1,
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

  t1_6_summary <- t1_6_flagged %>%
    mutate(
      Assessment = "AE"
    ) %>%
    select(SiteID, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
    arrange(desc(abs(KRI))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t1_6 <- list(
    "strFunctionName" = "AE_Assess()",
    "lParams" = list(
      "dfInput" = "dfInput",
      "vThreshold" = c("c", "0.1", "NA"),
      "strMethod" = "wilcoxon",
      "bChart" = "FALSE"
    ),
    "lTags" = list(Assessment = "AE"),
    "dfInput" = t1_6_input,
    "dfTransformed" = t1_6_transformed,
    "dfAnalyzed" = t1_6_analyzed,
    "dfFlagged" = t1_6_flagged,
    "dfSummary" = t1_6_summary
  )

  # compare results
  expect_equal(test1_6, t1_6)
})
