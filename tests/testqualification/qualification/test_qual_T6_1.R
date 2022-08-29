test_that("Labs assessment can return a correctly assessed data frame for the chisq test grouped by the site variable when given correct input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- gsm::LB_Map_Raw()

  test6_1 <- LB_Assess(
    dfInput = dfInput,
    bChart = FALSE
  )

  # Double Programming
  t6_1_input <- dfInput

  t6_1_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
      KRILabel = "% Abnormal Labs"
    )

  t6_1_analyzed <- t6_1_transformed %>%
    qualification_analyze_chisq()

  class(t6_1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_1_flagged <- t6_1_analyzed %>%
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

  t6_1_summary <- t6_1_flagged %>%
    mutate(
      Assessment = "Labs"
    ) %>%
    select(GroupID, GroupLabel, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
    arrange(desc(abs(KRI))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t6_1 <- list(
    "strFunctionName" = "LB_Assess()",
    "lTags" = list(Assessment = "Labs"),
    "dfInput" = t6_1_input,
    "dfTransformed" = t6_1_transformed,
    "dfAnalyzed" = t6_1_analyzed,
    "dfFlagged" = t6_1_flagged,
    "dfSummary" = t6_1_summary
  )

  # compare results
  expect_equal(test6_1, t6_1)
})
