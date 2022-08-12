test_that("Disposition assessment can return a correctly assessed data frame for the chisq test grouped by the site variable when given correct input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- gsm::Disp_Map_Raw()

  test5_3 <- Disp_Assess(
    dfInput = dfInput,
    strMethod = "fisher",
    bChart = FALSE
  )

  # Double Programming
  t5_3_input <- dfInput

  t5_3_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
      KRILabel = "% Discontinuation"
    )

  t5_3_analyzed <- t5_3_transformed %>%
    qualification_analyze_fisher()

  class(t5_3_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_3_flagged <- t5_3_analyzed %>%
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

  t5_3_summary <- t5_3_flagged %>%
    mutate(
      Assessment = "Disposition"
    ) %>%
    select(GroupID, GroupLabel, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
    arrange(desc(abs(KRI))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t5_3 <- list(
    "strFunctionName" = "Disp_Assess()",
    "lParams" = list(
      "dfInput" = "dfInput",
      "strMethod" = "fisher",
      "bChart" = "FALSE"
    ),
    "lTags" = list(Assessment = "Disposition"),
    "dfInput" = t5_3_input,
    "dfTransformed" = t5_3_transformed,
    "dfAnalyzed" = t5_3_analyzed,
    "dfFlagged" = t5_3_flagged,
    "dfSummary" = t5_3_summary
  )

  # compare results
  expect_equal(test5_3, t5_3)
})
