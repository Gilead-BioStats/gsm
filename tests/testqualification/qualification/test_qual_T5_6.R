test_that("Disposition assessment can return a correctly assessed data frame grouped by the study variable when given correct input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- Disp_Map_Raw()

  test5_6 <- Disp_Assess(
    dfInput = dfInput,
    strMethod = "identity",
    strGroup = "Study",
    bChart = FALSE
  )

  # Double Programming
  t5_6_input <- dfInput

  t5_6_transformed <- dfInput %>%
    qualification_transform_counts(exposureCol = "Total",
                                   KRILabel = "% Discontinuation",
                                   GroupLabel = "StudyID")

  t5_6_analyzed <- t5_6_transformed %>%
    mutate(
      Score = KRI,
      ScoreLabel = "% Discontinuation"
    ) %>%
    arrange(Score)

  class(t5_6_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_6_flagged <- t5_6_analyzed %>%
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

  t5_6_summary <- t5_6_flagged %>%
    mutate(
      Assessment = "Disposition"
    ) %>%
    select(GroupID, GroupLabel, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
    arrange(desc(abs(KRI))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t5_6 <- list(
    "strFunctionName" = "Disp_Assess()",
    "lParams" = list(
      "dfInput" = "dfInput",
      "strMethod" = "identity",
      "strGroup" = "Study",
      "bChart" = "FALSE"
    ),
    "lTags" = list(Assessment = "Disposition"),
    "dfInput" = t5_6_input,
    "dfTransformed" = t5_6_transformed,
    "dfAnalyzed" = t5_6_analyzed,
    "dfFlagged" = t5_6_flagged,
    "dfSummary" = t5_6_summary
  )

  # compare results
  expect_equal(test5_6, t5_6)
})
