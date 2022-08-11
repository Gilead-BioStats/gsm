test_that("Disposition assessment can return a correctly assessed data frame for the chisq test grouped by a custom variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- gsm::Disp_Map_Raw()

  test5_2 <- Disp_Assess(
    dfInput = dfInput,
    strGroup = "CustomGroup",
    vThreshold = c(.01, NA),
    bChart = FALSE
  )

  # Double Programming
  t5_2_input <- dfInput

  t5_2_transformed <- dfInput %>%
    qualification_transform_counts(exposureCol = "Total",
                                   KRILabel = "% Discontinuation",
                                   GroupLabel = "CustomGroupID")

  t5_2_analyzed <- t5_2_transformed %>%
    qualification_analyze_chisq()

  class(t5_2_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_2_flagged <- t5_2_analyzed %>%
    mutate(
      ThresholdLow = .01,
      ThresholdHigh = NA_integer_,
      ThresholdCol = "Score",
      Flag = case_when(
        Score < .01 ~ -1,
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

  t5_2_summary <- t5_2_flagged %>%
    mutate(
      Assessment = "Disposition"
    ) %>%
    select(GroupID, GroupLabel, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
    arrange(desc(abs(KRI))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t5_2 <- list(
    "strFunctionName" = "Disp_Assess()",
    "lParams" = list(
      "dfInput" = "dfInput",
      "vThreshold" = c("c", "0.01", "NA"),
      "strGroup" = "CustomGroup",
      "bChart" = "FALSE"
    ),
    "lTags" = list(Assessment = "Disposition"),
    "dfInput" = t5_2_input,
    "dfTransformed" = t5_2_transformed,
    "dfAnalyzed" = t5_2_analyzed,
    "dfFlagged" = t5_2_flagged,
    "dfSummary" = t5_2_summary
  )

  # compare results
  expect_equal(test5_2, t5_2)
})
