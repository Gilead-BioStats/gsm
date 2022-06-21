test_that("PD assessment can return a correctly assessed data frame for the poisson test grouped by the study variable and the results should be flagged correctly when done in an iterative loop", {
  test2_3 <- list()
  t2_3 <- list()

  for (type in unique(clindata::rawplus_pd$PD_CATEGORY)) {
    dfInput <- PD_Map_Raw(dfs = list(
      dfPD = clindata::rawplus_pd %>% filter(PD_CATEGORY == type),
      dfSUBJ = clindata::rawplus_subj
    ))

    # gsm
    test2_3 <- c(test2_3,
      type = PD_Assess(dfInput,
        strMethod = "poisson",
        bChart = FALSE
      )
    )


    # Double Programming
    t2_3_input <- dfInput

    t2_3_transformed <- dfInput %>%
      qualification_transform_counts(KRILabel = "PDs/Week")

    t2_3_analyzed <- t2_3_transformed %>%
      qualification_analyze_poisson()

    class(t2_3_analyzed) <- c("tbl_df", "tbl", "data.frame")

    t2_3_flagged <- t2_3_analyzed %>%
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

    t2_3_summary <- t2_3_flagged %>%
      mutate(
        Assessment = "PD"
      ) %>%
      select(SiteID, N, KRI, KRILabel, Score, ScoreLabel, Flag, Assessment) %>%
      arrange(desc(abs(KRI))) %>%
      arrange(match(Flag, c(1, -1, 0)))

    t2_3 <- c(t2_3,
      type = list(
        "strFunctionName" = "PD_Assess()",
        "lParams" = list(
          "dfInput" = "dfInput",
          "strMethod" = "poisson",
          "bChart" = "FALSE"
        ),
        "lTags" = list(Assessment = "PD"),
        "dfInput" = t2_3_input,
        "dfTransformed" = t2_3_transformed,
        "dfAnalyzed" = t2_3_analyzed,
        "dfFlagged" = t2_3_flagged,
        "dfSummary" = t2_3_summary
      )
    )
  }

  # compare results
  expect_equal(test2_3, t2_3)
})
