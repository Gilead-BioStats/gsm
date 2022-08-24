test_that("Disposition assessment can return a correctly assessed data frame for the chisq test grouped by the site variable when given correct input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- gsm::Disp_Map_Raw()

  test5_1 <- Disp_Assess(
    dfInput = dfInput,
    bChart = FALSE
  )

  # Double Programming
  t5_1_input <- dfInput

  t5_1_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
      KRILabel = "% Discontinuation"
    )

  t5_1_analyzed <- t5_1_transformed %>%
    qualification_analyze_chisq()

  class(t5_1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_1_flagged <- t5_1_analyzed %>%
    mutate(
      ThresholdLow = .05,
      ThresholdHigh = NA_integer_,
      ThresholdCol = "Score",
      Flag = case_when(
        Score < .05 ~ -1,
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

  t5_1_summary <- t5_1_flagged %>%
    mutate(
      Assessment = "Disposition"
    ) %>%
    select(GroupID, GroupLabel, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
    arrange(desc(abs(KRI))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t5_1 <- list(
    "strFunctionName" = "Disp_Assess()",
    "lTags" = list(Assessment = "Disposition"),
    "dfInput" = t5_1_input,
    "dfTransformed" = t5_1_transformed,
    "dfAnalyzed" = t5_1_analyzed,
    "dfFlagged" = t5_1_flagged,
    "dfSummary" = t5_1_summary
  )

  # compare results
  expect_equal(test5_1, t5_1)
})
