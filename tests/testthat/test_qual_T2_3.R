test_that("PD assessment can return a correctly assessed data frame for the poisson test grouped by the study variable and the results should be flagged correctly when done in an iterative loop", {
  test2_3 <- list()
  t2_3  <- list()

  for(type in unique(clindata::raw_protdev$DEVTYPE)){
    dfInput <- suppressWarnings(
      PD_Map_Raw(dfPD = clindata::raw_protdev %>% filter(SUBJID != "" & DEVTYPE == type),
       dfRDSL = clindata::rawplus_rdsl %>% filter(!is.na(TimeOnTreatment))))

    # gsm
    test2_3 <- c(test2_3,
                 type = PD_Assess(dfInput,
                                  strMethod = "poisson"))


    # Double Programming
    t2_3_input <- dfInput

    t2_3_transformed <- dfInput %>%
      qualification_transform_counts()

    t2_3_analyzed <- t2_3_transformed %>%
      qualification_analyze_poisson()

    class(t2_3_analyzed) <- c("tbl_df", "tbl", "data.frame")

    t2_3_flagged <- t2_3_analyzed %>%
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

    t2_3_summary <- t2_3_flagged %>%
      mutate(
        Assessment = "PD",
        Score = Residuals
      ) %>%
      select(SiteID, N, Score, Flag, Assessment) %>%
      arrange(desc(abs(Score))) %>%
      arrange(match(Flag, c(1, -1, 0)))

    t2_3 <- c(t2_3,
              type = list("strFunctionName" = "PD_Assess()",
                          "lParams" = list("dfInput" = "dfInput",
                                           "strMethod" = "poisson"),
                          "lTags" = list(Assessment = "PD"),
                          "dfInput" = t2_3_input,
                          "dfTransformed" = t2_3_transformed,
                          "dfAnalyzed" = t2_3_analyzed,
                          "dfFlagged" = t2_3_flagged,
                          "dfSummary" = t2_3_summary))

  }

  # compare results
  expect_equal(test2_3, t2_3)
})
