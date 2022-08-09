test_that("Disposition assessment can return a correctly assessed data frame grouped by the site variable when given correct input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- Disp_Map_Raw()

  test5_5 <- Disp_Assess(
    dfInput = dfInput,
    strMethod = "identity",
    bChart = FALSE
  )

  # Double Programming
  t5_5_input <- dfInput

  t5_5_transformed <- dfInput %>%
    qualification_transform_counts(exposureCol = "Total",
                                   KRILabel = "% Discontinuation")

  t5_5_analyzed <- t5_5_transformed %>%
    mutate(
      Score = KRI,
      ScoreLabel = "% Discontinuation"
    )

  class(t5_5_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_5_flagged <- t5_5_analyzed %>%
    mutate(
      ThresholdLow = 3.491,
      ThresholdHigh = 5.172,
      ThresholdCol = "Score",
      Flag = case_when(
        Score < 3.491 ~ 1,
        Score > 5.172 ~ 1,
        is.na(Score) ~ NA_real_,
        is.nan(Score) ~ NA_real_,
        TRUE ~ 0
      ),
    ) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t5_5_summary <- t5_5_flagged %>%
    mutate(
      Assessment = "Disposition"
    ) %>%
    select(GroupID, GroupLabel, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
    arrange(desc(abs(KRI))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t5_5 <- list(
    "strFunctionName" = "Disp_Assess()",
    "lParams" = list(
      "dfInput" = "dfInput",
      "strMethod" = "identity",
      "bChart" = "FALSE"
    ),
    "lTags" = list(Assessment = "Disposition"),
    "dfInput" = t5_5_input,
    "dfTransformed" = t5_5_transformed,
    "dfAnalyzed" = t5_5_analyzed,
    "dfFlagged" = t5_5_flagged,
    "dfSummary" = t5_5_summary
  )

  # compare results
  expect_equal(test5_5, t5_5)
})
