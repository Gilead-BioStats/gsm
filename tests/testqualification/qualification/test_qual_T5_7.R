test_that("Disposition assessment can return a correctly assessed data frame grouped by a custom variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- Disp_Map_Raw()

  test5_7 <- Disp_Assess(
    dfInput = dfInput,
    strMethod = "identity",
    strGroup = "CustomGroup",
    vThreshold = c(2.31, 6.58),
    bChart = FALSE
  )

  # Double Programming
  t5_7_input <- dfInput

  t5_7_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
      KRILabel = "% Discontinuation",
      GroupLabel = "CustomGroupID"
    )

  t5_7_analyzed <- t5_7_transformed %>%
    mutate(
      Score = KRI,
      ScoreLabel = "% Discontinuation"
    ) %>%
    arrange(Score)

  class(t5_7_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_7_flagged <- t5_7_analyzed %>%
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

  t5_7_summary <- t5_7_flagged %>%
    mutate(
      Assessment = "Disposition"
    ) %>%
    select(GroupID, GroupLabel, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
    arrange(desc(abs(KRI))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t5_7 <- list(
    "strFunctionName" = "Disp_Assess()",
    "lTags" = list(Assessment = "Disposition"),
    "dfInput" = t5_7_input,
    "dfTransformed" = t5_7_transformed,
    "dfAnalyzed" = t5_7_analyzed,
    "dfFlagged" = t5_7_flagged,
    "dfSummary" = t5_7_summary
  )

  # compare results
  expect_equal(test5_7, t5_7)
})
