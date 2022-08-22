test_that("Labs assessment can return a correctly assessed data frame grouped by a custom variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- LB_Map_Raw()

  test6_7 <- LB_Assess(
    dfInput = dfInput,
    strMethod = "identity",
    strGroup = "CustomGroup",
    vThreshold = c(2.31, 6.58),
    bChart = FALSE
  )

  # Double Programming
  t6_7_input <- dfInput

  t6_7_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
      KRILabel = "% Abnormal Labs",
      GroupLabel = "CustomGroupID"
    )

  t6_7_analyzed <- t6_7_transformed %>%
    mutate(
      Score = KRI,
      ScoreLabel = "% Abnormal Labs"
    ) %>%
    arrange(Score)

  class(t6_7_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_7_flagged <- t6_7_analyzed %>%
    mutate(
      ThresholdLow = 2.31,
      ThresholdHigh = 6.58,
      ThresholdCol = "Score",
      Flag = case_when(
        Score < 2.31 ~ -1,
        Score > 6.58 ~ 1,
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

  t6_7_summary <- t6_7_flagged %>%
    mutate(
      Assessment = "Labs"
    ) %>%
    select(GroupID, GroupLabel, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
    arrange(desc(abs(KRI))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t6_7 <- list(
    "strFunctionName" = "LB_Assess()",
    "lParams" = list(
      "dfInput" = "dfInput",
      "vThreshold" = c("c", "2.31", "6.58"),
      "strMethod" = "identity",
      "strGroup" = "CustomGroup",
      "bChart" = "FALSE"
    ),
    "lTags" = list(Assessment = "Labs"),
    "dfInput" = t6_7_input,
    "dfTransformed" = t6_7_transformed,
    "dfAnalyzed" = t6_7_analyzed,
    "dfFlagged" = t6_7_flagged,
    "dfSummary" = t6_7_summary
  )

  # compare results
  expect_equal(test6_7, t6_7)
})
