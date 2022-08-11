test_that("Consent assessment can return a correctly assessed data frame grouped by the study variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- Consent_Map_Raw()

  test4_2 <- Consent_Assess(
    dfInput = dfInput,
    bChart = FALSE,
    strGroup = "Study",
    nThreshold = 1.5
  )

  # Double Programming
  t4_2_input <- dfInput

  t4_2_transformed <- dfInput %>%
    qualification_transform_counts(exposureCol = NA,
                                   KRILabel = "Total Number of Consent Issues",
                                   GroupLabel = "StudyID")

  t4_2_analyzed <- t4_2_transformed %>%
    mutate(
      Score = TotalCount,
      ScoreLabel = "Total Number of Consent Issues"
    ) %>%
    arrange(Score)

  class(t4_2_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t4_2_flagged <- t4_2_analyzed %>%
    mutate(
      ThresholdLow = NA_real_,
      ThresholdHigh = 1.5,
      ThresholdCol = "Score",
      Flag = case_when(
        Score > 1.5 ~ 1,
        is.na(Score) ~ NA_real_,
        is.nan(Score) ~ NA_real_,
        TRUE ~ 0
      ),
    ) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t4_2_summary <- t4_2_flagged %>%
    mutate(
      Assessment = "Consent"
    ) %>%
    select(GroupID, GroupLabel, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
    arrange(desc(abs(KRI))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t4_2 <- list(
    "strFunctionName" = "Consent_Assess()",
    "lParams" = list(
      "dfInput" = "dfInput",
      "nThreshold" = "1.5",
      "strGroup" = "Study",
      "bChart" = "FALSE"
    ),
    "lTags" = list(Assessment = "Consent"),
    "dfInput" = t4_2_input,
    "dfTransformed" = t4_2_transformed,
    "dfAnalyzed" = t4_2_analyzed,
    "dfFlagged" = t4_2_flagged,
    "dfSummary" = t4_2_summary
  )

  # compare results
  expect_equal(test4_2, t4_2)
})
