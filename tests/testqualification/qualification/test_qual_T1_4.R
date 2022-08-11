test_that("AE assessment can return a correctly assessed data frame for the poisson test grouped by the site variable and the results should be flagged correctly when done in an iterative loop", {
  test1_4 <- list()
  t1_4 <- list()

  for (severity in unique(clindata::rawplus_ae$AE_GRADE)) {
    dfInput <- AE_Map_Raw(dfs = list(
      dfAE = filter(clindata::rawplus_ae, AE_GRADE == severity),
      dfSUBJ = clindata::rawplus_subj
    ))

    # gsm
    test1_4 <- c(test1_4,
      severity = AE_Assess(dfInput,
        strMethod = "poisson",
        bChart = FALSE
      )
    )

    # Double Programming
    t1_4_input <- dfInput

    t1_4_transformed <- dfInput %>%
      qualification_transform_counts(KRILabel = "AEs/Week")

    t1_4_analyzed <- t1_4_transformed %>%
      qualification_analyze_poisson()

    class(t1_4_analyzed) <- c("tbl_df", "tbl", "data.frame")

    t1_4_flagged <- t1_4_analyzed %>%
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

    t1_4_summary <- t1_4_flagged %>%
      mutate(
        Assessment = "AE"
      ) %>%
      select(GroupID, GroupLabel, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
      arrange(desc(abs(KRI))) %>%
      arrange(match(Flag, c(1, -1, 0)))

    t1_4 <- c(t1_4,
      severity = list(
        "strFunctionName" = "AE_Assess()",
        "lParams" = list(
          "dfInput" = "dfInput",
          "strMethod" = "poisson",
          "bChart" = "FALSE"
        ),
        "lTags" = list(Assessment = "AE"),
        "dfInput" = t1_4_input,
        "dfTransformed" = t1_4_transformed,
        "dfAnalyzed" = t1_4_analyzed,
        "dfFlagged" = t1_4_flagged,
        "dfSummary" = t1_4_summary
      )
    )
  }

  # compare results
  expect_equal(test1_4, t1_4)
})
