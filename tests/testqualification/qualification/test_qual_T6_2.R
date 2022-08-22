test_that("Labs assessment can return a correctly assessed data frame for the chisq test grouped by a custom variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- gsm::LB_Map_Raw()

  test6_2 <- LB_Assess(
    dfInput = dfInput,
    strGroup = "CustomGroup",
    vThreshold = c(.01, NA),
    bChart = FALSE
  )

  # Double Programming
  t6_2_input <- dfInput

  t6_2_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
      KRILabel = "% Abnormal Labs",
      GroupLabel = "CustomGroupID"
    )

  t6_2_analyzed <- t6_2_transformed %>%
    qualification_analyze_chisq()

  class(t6_2_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_2_flagged <- t6_2_analyzed %>%
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

  t6_2_summary <- t6_2_flagged %>%
    mutate(
      Assessment = "Labs"
    ) %>%
    select(GroupID, GroupLabel, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
    arrange(desc(abs(KRI))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t6_2 <- list(
    "strFunctionName" = "LB_Assess()",
    "lParams" = list(
      "dfInput" = "dfInput",
      "vThreshold" = c("c", "0.01", "NA"),
      "strGroup" = "CustomGroup",
      "bChart" = "FALSE"
    ),
    "lTags" = list(Assessment = "Labs"),
    "dfInput" = t6_2_input,
    "dfTransformed" = t6_2_transformed,
    "dfAnalyzed" = t6_2_analyzed,
    "dfFlagged" = t6_2_flagged,
    "dfSummary" = t6_2_summary
  )

  # compare results
  expect_equal(test6_2, t6_2)
})
