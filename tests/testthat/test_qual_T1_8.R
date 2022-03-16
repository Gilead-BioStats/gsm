test_that("AE assessment can return a correctly assessed data frame for the wilcoxon test grouped by the study variable and the results should be flagged correctly when done in an iterative loop", {
  test1_8_assess <- vector("list", length(unique(clindata::raw_ae$AESEV)))
  t1_8_assess  <- vector("list", length(unique(clindata::raw_ae$AESEV)))

  names(test1_8_assess) <- unique(clindata::raw_ae$AESEV)
  names(t1_8_assess) <- unique(clindata::raw_ae$AESEV)

  for(severity in unique(clindata::raw_ae$AESEV)){
    dfInput <- AE_Map_Raw(dfAE = filter(clindata::raw_ae, AESEV == severity),
                          dfRDSL = clindata::rawplus_rdsl)

    # gsm
    test1_8_assess[severity] <- AE_Assess(dfInput,
                                          strMethod = "wilcoxon")


    # Double Programming
    t1_8_input <- dfInput

    t1_8_transformed <- dfInput %>%
      qualification_transform_counts()

    t1_8_analyzed <- t1_8_transformed %>%
      qualification_analyze_wilcoxon()

    class(t1_8_analyzed) <- c("tbl_df", "tbl", "data.frame")

    t1_8_flagged <- t1_8_analyzed %>%
      mutate(
        ThresholdLow = 0.0001,
        ThresholdHigh = NA_integer_,
        ThresholdCol = "PValue",
        Flag = case_when(
          PValue < 0.0001 ~ -1,
          is.na(PValue) ~ NA_real_,
          is.nan(PValue) ~ NA_real_,
          TRUE ~ 0),
        median = median(Estimate),
        Flag = case_when(
          Flag != 0 & Estimate >= median ~ 1,
          Flag != 0 & Estimate < median ~ -1,
          TRUE ~ Flag)
      ) %>%
      select(-median) %>%
      arrange(match(Flag, c(1, -1, 0)))

    t1_8_summary <- t1_8_flagged %>%
      mutate(
        Assessment = "Safety",
        Label = "",
        Score = PValue
      ) %>%
      select(Assessment, Label, SiteID, N, Score, Flag) %>%
      arrange(desc(abs(Score))) %>%
      arrange(match(Flag, c(1, -1, 0)))


    t1_8_assess[severity] <- list("strFunctionName" = "AE_Assess()",
                                  "lParams" = list("dfInput" = "dfInput",
                                                   "strMethod" = "wilcoxon"),
                                  "dfInput" = t1_8_input,
                                  "dfTransformed" = t1_8_transformed,
                                  "dfAnalyzed" = t1_8_analyzed,
                                  "dfFlagged" = t1_8_flagged,
                                  "dfSummary" = t1_8_summary)

  }

  test1_8 <- test1_8_assess$dfSummary %>% bind_rows()
  t1_8 <- t1_8_assess$dfSummary %>% bind_rows()

  # compare results
  expect_equal(test1_8, t1_8)
})
