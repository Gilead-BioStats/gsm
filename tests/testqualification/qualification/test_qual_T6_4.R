test_that("Labs assessment can return a correctly assessed data frame for the chisq test grouped by a custom variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- gsm::LB_Map_Raw()

  test6_4 <- LB_Assess(
    dfInput = dfInput,
    strMethod = "fisher",
    vThreshold = c(.01, NA),
    strGroup = "CustomGroup",
    bChart = FALSE
  )

  # Double Programming
  t6_4_input <- dfInput

  t6_4_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
      KRILabel = "% Abnormal Labs",
      GroupLabel = "CustomGroupID"
    )

  t6_4_analyzed <- t6_4_transformed %>%
    qualification_analyze_fisher()

  class(t6_4_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_4_flagged <- t6_4_analyzed %>%
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

  t6_4_summary <- t6_4_flagged %>%
    mutate(
      Assessment = "Labs"
    ) %>%
    select(GroupID, GroupLabel, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
    arrange(desc(abs(KRI))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t6_4 <- list(
    "strFunctionName" = "LB_Assess()",
    "lParams" = list(
      "dfInput" = "dfInput",
      "vThreshold" = c("c", "0.01", "NA"),
      "strMethod" = "fisher",
      "strGroup" = "CustomGroup",
      "bChart" = "FALSE"
    ),
    "lTags" = list(Assessment = "Labs"),
    "dfInput" = t6_4_input,
    "dfTransformed" = t6_4_transformed,
    "dfAnalyzed" = t6_4_analyzed,
    "dfFlagged" = t6_4_flagged,
    "dfSummary" = t6_4_summary
  )

  # compare results
  expect_equal(test6_4, t6_4)
})
