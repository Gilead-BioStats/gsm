test_that("Consent assessment can return a correctly assessed data frame grouped by a custom variable when given correct input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- Consent_Map_Raw()

  test4_3 <- Consent_Assess(
    dfInput = dfInput,
    bChart = FALSE,
    strGroup = "CustomGroup"
  )

  # Double Programming
  t4_3_input <- dfInput

  t4_3_transformed <- dfInput %>%
    qualification_transform_counts(exposureCol = NA,
                                   KRILabel = "Total Number of Consent Issues",
                                   GroupLabel = "CustomGroupID")

  t4_3_analyzed <- t4_3_transformed %>%
    mutate(
      Score = TotalCount,
      ScoreLabel = "Total Number of Consent Issues"
    ) %>%
    arrange(Score)

  class(t4_3_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t4_3_flagged <- t4_3_analyzed %>%
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

  t4_3_summary <- t4_3_flagged %>%
    mutate(
      Assessment = "Consent"
    ) %>%
    select(GroupID, GroupLabel, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
    arrange(desc(abs(KRI))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t4_3 <- list(
    "strFunctionName" = "Consent_Assess()",
    "lParams" = list(
      "dfInput" = "dfInput",
      "strGroup" = "CustomGroup",
      "bChart" = "FALSE"
    ),
    "lTags" = list(Assessment = "Consent"),
    "dfInput" = t4_3_input,
    "dfTransformed" = t4_3_transformed,
    "dfAnalyzed" = t4_3_analyzed,
    "dfFlagged" = t4_3_flagged,
    "dfSummary" = t4_3_summary
  )

  # compare results
  expect_equal(test4_3, t4_3)
})
