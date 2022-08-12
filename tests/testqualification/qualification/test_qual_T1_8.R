test_that("AE assessment can return a correctly assessed data frame for the wilcoxon test grouped by the site variable and the results should be flagged correctly when done in an iterative loop", {
  test1_8 <- list()
  t1_8 <- list()

  for (severity in unique(clindata::rawplus_ae$AE_GRADE)) {
    dfInput <- AE_Map_Raw(dfs = list(
      dfAE = filter(clindata::rawplus_ae, AE_GRADE == severity),
      dfSUBJ = clindata::rawplus_subj
    ))

    # gsm
    test1_8 <- c(test1_8,
      severity = AE_Assess(dfInput,
        strMethod = "wilcoxon",
        bChart = FALSE
      )
    )

    # Double Programming
    t1_8_input <- dfInput

    t1_8_transformed <- dfInput %>%
      qualification_transform_counts(KRILabel = "AEs/Week")

    t1_8_analyzed <- t1_8_transformed %>%
      qualification_analyze_wilcoxon()

    class(t1_8_analyzed) <- c("tbl_df", "tbl", "data.frame")
    names(t1_8_analyzed$Estimate) <- rep("difference in location", nrow(t1_8_analyzed))

    t1_8_flagged <- t1_8_analyzed %>%
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

    t1_8_summary <- t1_8_flagged %>%
      mutate(
        Assessment = "AE"
      ) %>%
      select(GroupID, GroupLabel, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
      arrange(desc(abs(KRI))) %>%
      arrange(match(Flag, c(1, -1, 0)))

    t1_8 <- c(t1_8,
      severity = list(
        "strFunctionName" = "AE_Assess()",
        "lParams" = list(
          "dfInput" = "dfInput",
          "strMethod" = "wilcoxon",
          "bChart" = "FALSE"
        ),
        "lTags" = list(Assessment = "AE"),
        "dfInput" = t1_8_input,
        "dfTransformed" = t1_8_transformed,
        "dfAnalyzed" = t1_8_analyzed,
        "dfFlagged" = t1_8_flagged,
        "dfSummary" = t1_8_summary
      )
    )
  }

  # compare results
  expect_equal(test1_8, t1_8)
})
