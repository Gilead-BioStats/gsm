test_that("PD assessment can return a correctly assessed data frame for the poisson test grouped by a custom variable when given subset input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw(dfs = list(
    dfPD = clindata::rawplus_pd %>% filter(PD_IMPORTANT_FLAG == "Y"),
    dfSUBJ = clindata::rawplus_subj
  ))

  test2_2 <- PD_Assess(
    dfInput = dfInput,
    strMethod = "poisson",
    strGroup = "CustomGroup",
    bChart = FALSE
  )

  # Double Programming
  t2_2_input <- dfInput

  t2_2_transformed <- dfInput %>%
    qualification_transform_counts(KRILabel = "PDs/Week",
                                   GroupLabel = "CustomGroupID")

  t2_2_analyzed <- t2_2_transformed %>%
    qualification_analyze_poisson()

  class(t2_2_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t2_2_flagged <- t2_2_analyzed %>%
    mutate(
      ThresholdLow = -5,
      ThresholdHigh = 5,
      ThresholdCol = "Score",
      Flag = case_when(
        Score < -5 ~ -1,
        Score > 5 ~ 1,
        is.na(Score) ~ NA_real_,
        is.nan(Score) ~ NA_real_,
        TRUE ~ 0
      ),
    ) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t2_2_summary <- t2_2_flagged %>%
    mutate(
      Assessment = "PD"
    ) %>%
    select(GroupID, GroupLabel, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
    arrange(desc(abs(KRI))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t2_2 <- list(
    "strFunctionName" = "PD_Assess()",
    "lParams" = list(
      "dfInput" = "dfInput",
      "strMethod" = "poisson",
      "strGroup" = "CustomGroup",
      "bChart" = "FALSE"
    ),
    "lTags" = list(Assessment = "PD"),
    "dfInput" = t2_2_input,
    "dfTransformed" = t2_2_transformed,
    "dfAnalyzed" = t2_2_analyzed,
    "dfFlagged" = t2_2_flagged,
    "dfSummary" = t2_2_summary
  )

  # compare results
  expect_equal(test2_2, t2_2)
})
