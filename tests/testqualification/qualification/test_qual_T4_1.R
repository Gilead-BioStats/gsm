test_that("Consent assessment can return a correctly assessed data frame grouped by the site variable when given correct input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- Consent_Map_Raw()

  test4_1 <- Consent_Assess(
    dfInput = dfInput,
    bChart = FALSE
  )

  # Double Programming
  t4_1_input <- dfInput

  t4_1_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = NA,
      KRILabel = "Total Number of Consent Issues"
    )

  t4_1_analyzed <- t4_1_transformed %>%
    mutate(
      Score = TotalCount,
      ScoreLabel = "Total Number of Consent Issues"
    ) %>%
    arrange(Score)

  class(t4_1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t4_1_flagged <- t4_1_analyzed %>%
    mutate(
      ThresholdLow = NA_real_,
      ThresholdHigh = 0.5,
      ThresholdCol = "Score",
      Flag = case_when(
        Score > 0.5 ~ 1,
        is.na(Score) ~ NA_real_,
        is.nan(Score) ~ NA_real_,
        TRUE ~ 0
      ),
    ) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t4_1_summary <- t4_1_flagged %>%
    mutate(
      Assessment = "Consent"
    ) %>%
    select(GroupID, GroupLabel, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
    arrange(desc(abs(KRI))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t4_1 <- list(
    "strFunctionName" = "Consent_Assess()",
    "lTags" = list(Assessment = "Consent"),
    "dfInput" = t4_1_input,
    "dfTransformed" = t4_1_transformed,
    "dfAnalyzed" = t4_1_analyzed,
    "dfFlagged" = t4_1_flagged,
    "dfSummary" = t4_1_summary
  )

  # compare results
  expect_equal(test4_1, t4_1)
})
