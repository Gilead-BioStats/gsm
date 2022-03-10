test_that("AE assessment can return a correctly assessed data frame for the wilcoxon test grouped by the study variable when given correct input data from safetyData and the results should be flagged correctly.", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Adam(
    dfADSL = safetyData::adam_adsl,
    dfADAE = safetyData::adam_adae
  )

  test1_3 <- AE_Assess(
    dfInput = dfInput,
    strMethod = "wilcoxon"
  )

  # double programming
  t1_3_input <- dfInput

  t1_3_transformed <- dfInput %>%
    qualification_transform_counts()

  t1_3_analyzed <- t1_3_transformed %>%
    qualification_analyze_wilcoxon()

  class(t1_3_analyzed) <- c("tbl_df", "tbl", "data.frame")
  names(t1_3_analyzed$Estimate) <- rep("difference in location", nrow(t1_3_analyzed))

  t1_3_flagged <- t1_3_analyzed %>%
    mutate(
      ThresholdLow = .0001,
      ThresholdHigh = NA_integer_,
      ThresholdCol = "PValue",
      Flag = case_when(
        PValue < 0.0001 ~ -1,
        is.na(PValue) ~ NA_real_,
        is.nan(PValue) ~ NA_real_,
        TRUE ~ 0),
      median = median(Estimate),
      Flag = case_when(
        Flag != 0 & Estimate < median ~ -1,
        Flag != 0 & Estimate >= median ~ 1,
        TRUE ~ Flag)
    ) %>%
    select(-median)

  t1_3_summary <- t1_3_flagged %>%
    mutate(
      Assessment = "Safety",
      Label = "",
      Score = PValue
    ) %>%
    select(Assessment, Label, SiteID, N, Score, Flag)

  t1_3 <- list("strFunctionName" = "AE_Assess()",
             "lParams" = list("dfInput" = "dfInput",
                              "strMethod" = "wilcoxon"),
             "dfInput" = t1_3_input,
             "dfTransformed" = t1_3_transformed,
             "dfAnalyzed" = t1_3_analyzed,
             "dfFlagged" = t1_3_flagged,
             "dfSummary" = t1_3_summary)

  # compare results
  expect_equal(test1_3, t1_3)

})
