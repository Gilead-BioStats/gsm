test_that("Disposition assessment can return a correctly assessed data frame for the chisq test grouped by a custom variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- gsm::Disp_Map_Raw()

  test5_4 <- Disp_Assess(
    dfInput = dfInput,
    strMethod = "fisher",
    vThreshold = c(.01, NA),
    strGroup = "CustomGroup",
    bChart = FALSE
  )

  # Double Programming
  t5_4_input <- dfInput

  t5_4_transformed <- dfInput %>%
    qualification_transform_counts(exposureCol = "Total",
                                   KRILabel = "% Discontinuation",
                                   GroupLabel = "CustomGroupID")

  t5_4_analyzed <- t5_4_transformed %>%
    qualification_analyze_fisher()

  class(t5_4_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_4_flagged <- t5_4_analyzed %>%
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

  t5_4_summary <- t5_4_flagged %>%
    mutate(
      Assessment = "Disposition"
    ) %>%
    select(GroupID, GroupLabel, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
    arrange(desc(abs(KRI))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t5_4 <- list(
    "strFunctionName" = "Disp_Assess()",
    "lParams" = list(
      "dfInput" = "dfInput",
      "vThreshold" = c("c", "0.01", "NA"),
      "strMethod" = "fisher",
      "strGroup" = "CustomGroup",
      "bChart" = "FALSE"
    ),
    "lTags" = list(Assessment = "Disposition"),
    "dfInput" = t5_4_input,
    "dfTransformed" = t5_4_transformed,
    "dfAnalyzed" = t5_4_analyzed,
    "dfFlagged" = t5_4_flagged,
    "dfSummary" = t5_4_summary
  )

  # compare results
  expect_equal(test5_4, t5_4)
})
