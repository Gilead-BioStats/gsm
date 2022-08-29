test_that("PD assessment can return a correctly assessed data frame for the wilcoxon test grouped by a custom variable when given subset input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw(dfs = list(
    dfPD = clindata::rawplus_pd %>% filter(PD_IMPORTANT_FLAG == "Y"),
    dfSUBJ = clindata::rawplus_subj
  ))

  test2_5 <- PD_Assess(
    dfInput = dfInput,
    strMethod = "wilcoxon",
    strGroup = "CustomGroup",
    bChart = FALSE
  )

  # double programming
  t2_5_input <- dfInput

  t2_5_transformed <- dfInput %>%
    qualification_transform_counts(
      KRILabel = "PDs/Week",
      GroupLabel = "CustomGroupID"
    )

  t2_5_analyzed <- t2_5_transformed %>%
    qualification_analyze_wilcoxon()

  class(t2_5_analyzed) <- c("tbl_df", "tbl", "data.frame")
  names(t2_5_analyzed$Estimate) <- rep("difference in location", nrow(t2_5_analyzed))

  t2_5_flagged <- t2_5_analyzed %>%
    mutate(
      ThresholdLow = 0.0001,
      ThresholdHigh = NA_integer_,
      ThresholdCol = "Score",
      Flag = case_when(
        Score < 0.0001 ~ -1,
        is.na(Score) ~ NA_real_,
        is.nan(Score) ~ NA_real_,
        TRUE ~ 0
      ),
      median = median(Estimate),
      Flag = case_when(
        Flag != 0 & Estimate >= median ~ 1,
        Flag != 0 & Estimate < median ~ -1,
        TRUE ~ Flag
      )
    ) %>%
    select(-median) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t2_5_summary <- t2_5_flagged %>%
    mutate(
      Assessment = "PD"
    ) %>%
    select(GroupID, GroupLabel, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
    arrange(desc(abs(KRI))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t2_5 <- list(
    "strFunctionName" = "PD_Assess()",
    "lTags" = list(Assessment = "PD"),
    "dfInput" = t2_5_input,
    "dfTransformed" = t2_5_transformed,
    "dfAnalyzed" = t2_5_analyzed,
    "dfFlagged" = t2_5_flagged,
    "dfSummary" = t2_5_summary
  )

  # compare results
  expect_equal(test2_5, t2_5)
})
