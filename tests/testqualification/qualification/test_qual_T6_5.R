test_that("Labs assessment can return a correctly assessed data frame grouped by the site variable when given correct input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- LB_Map_Raw()

  test6_5 <- LB_Assess(
    dfInput = dfInput,
    strMethod = "identity",
    bChart = FALSE
  )

  # Double Programming
  t6_6_input <- dfInput

  t6_6_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
      KRILabel = "% Abnormal Labs"
    )

  t6_6_analyzed <- t6_6_transformed %>%
    mutate(
      Score = KRI,
      ScoreLabel = "% Abnormal Labs"
    ) %>%
    arrange(Score)

  class(t6_6_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_6_flagged <- t6_6_analyzed %>%
    mutate(
      ThresholdLow = 3.491,
      ThresholdHigh = 5.172,
      ThresholdCol = "Score",
      Flag = case_when(
        Score < 3.491 ~ -1,
        Score > 5.172 ~ 1,
        is.na(Score) ~ NA_real_,
        is.nan(Score) ~ NA_real_,
        TRUE ~ 0
      ),
      median = median(KRI),
      Flag = case_when(
        Flag != 0 & KRI < median ~ -1,
        Flag != 0 & KRI >= median ~ 1,
        TRUE ~ Flag
      )
    ) %>%
    select(-median) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t6_6_summary <- t6_6_flagged %>%
    mutate(
      Assessment = "Labs"
    ) %>%
    select(GroupID, GroupLabel, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
    arrange(desc(abs(KRI))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t6_5 <- list(
    "strFunctionName" = "LB_Assess()",
    "lParams" = list(
      "dfInput" = "dfInput",
      "strMethod" = "identity",
      "bChart" = "FALSE"
    ),
    "lTags" = list(Assessment = "Labs"),
    "dfInput" = t6_6_input,
    "dfTransformed" = t6_6_transformed,
    "dfAnalyzed" = t6_6_analyzed,
    "dfFlagged" = t6_6_flagged,
    "dfSummary" = t6_6_summary
  )

  # compare results
  expect_equal(test6_5, t6_5)
})
