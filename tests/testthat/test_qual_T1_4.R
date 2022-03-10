test_that("AE assessment can return a correctly assessed data frame for the wilcoxon test grouped by the study variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Raw(
    dfAE = clindata::raw_ae,
    dfRDSL = clindata::rawplus_rdsl
  )

  test1_4 <- suppressWarnings(AE_Assess(
    dfInput = dfInput,
    strMethod = "wilcoxon",
    vThreshold = c(0.1, NA)
  ))

  # double programming
  t1_4_input <- dfInput

  t1_4_transformed <- dfInput %>%
    qualification_transform_counts()

  t1_4_analyzed <- t1_4_transformed %>%
    qualification_analyze_wilcoxon()

  class(t1_4_analyzed) <- c("tbl_df", "tbl", "data.frame")
  names(t1_4_analyzed$Estimate) <- rep("difference in location", nrow(t1_4_analyzed))

  t1_4_flagged <- t1_4_analyzed %>%
    mutate(
      ThresholdLow = 0.1,
      ThresholdHigh = NA_integer_,
      ThresholdCol = "PValue",
      Flag = case_when(
        PValue < 0.1 ~ -1,
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

  t1_4_summary <- t1_4_flagged %>%
    mutate(
      Assessment = "Safety",
      Label = "",
      Score = PValue
    ) %>%
    select(Assessment, Label, SiteID, N, Score, Flag)

  t1_4 <- list("strFunctionName" = "AE_Assess()",
               "lParams" = list("dfInput" = "dfInput",
                                "vThreshold" = c("c", "0.1", "NA"),
                                "strMethod" = "wilcoxon"),
               "dfInput" = t1_4_input,
               "dfTransformed" = t1_4_transformed,
               "dfAnalyzed" = t1_4_analyzed,
               "dfFlagged" = t1_4_flagged,
               "dfSummary" = t1_4_summary)

  # compare results
  expect_equal(test1_4, t1_4)
})
