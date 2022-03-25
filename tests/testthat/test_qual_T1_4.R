test_that("AE assessment can return a correctly assessed data frame for the poisson test grouped by the study variable and the results should be flagged correctly when done in an iterative loop", {
  test1_4 <- list()
  t1_4  <- list()

  for(severity in unique(clindata::raw_ae$AESEV)){
    dfInput <- suppressWarnings(AE_Map_Raw(dfAE = filter(clindata::raw_ae, AESEV == severity & SUBJID != ""),
                                dfRDSL = clindata::rawplus_rdsl %>% filter(!is.na(TimeOnTreatment))))

    # gsm
    test1_4 <- c(test1_4,
                 severity = AE_Assess(dfInput,
                                      strMethod = "poisson"))

    # Double Programming
    t1_4_input <- dfInput

    t1_4_transformed <- dfInput %>%
      qualification_transform_counts()

    t1_4_analyzed <- t1_4_transformed %>%
      qualification_analyze_poisson()

    class(t1_4_analyzed) <- c("tbl_df", "tbl", "data.frame")

    t1_4_flagged <- t1_4_analyzed %>%
      mutate(
        ThresholdLow = -5,
        ThresholdHigh = 5,
        ThresholdCol = "Residuals",
        Flag = case_when(
          Residuals < -5 ~ -1,
          Residuals > 5 ~ 1,
          is.na(Residuals) ~ NA_real_,
          is.nan(Residuals) ~ NA_real_,
          TRUE ~ 0),
      ) %>%
      arrange(match(Flag, c(1, -1, 0)))

    t1_4_summary <- t1_4_flagged %>%
      mutate(
        Assessment = "AE",
        Score = Residuals
      ) %>%
      select(SiteID, N, Score, Flag, Assessment) %>%
      arrange(desc(abs(Score))) %>%
      arrange(match(Flag, c(1, -1, 0)))

    t1_4 <- c(t1_4,
              severity = list("strFunctionName" = "AE_Assess()",
                              "lParams" = list("dfInput" = "dfInput",
                                               "strMethod" = "poisson"),
                              "lTags" = list(Assessment = "AE"),
                              "dfInput" = t1_4_input,
                              "dfTransformed" = t1_4_transformed,
                              "dfAnalyzed" = t1_4_analyzed,
                              "dfFlagged" = t1_4_flagged,
                              "dfSummary" = t1_4_summary))
  }

  # compare results
  expect_equal(test1_4, t1_4)
})
