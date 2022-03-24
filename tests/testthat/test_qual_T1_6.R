test_that("AE assessment can return a correctly assessed data frame for the wilcoxon test grouped by the study variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold.", {
  # gsm analysis
  dfInput <- suppressWarnings(gsm::AE_Map_Raw(
    dfAE = clindata::raw_ae %>% filter(SUBJID != ""),
    dfRDSL = clindata::rawplus_rdsl %>% filter(!is.na(TimeOnTreatment))
  ))

  test1_6 <- suppressWarnings(AE_Assess(
    dfInput = dfInput,
    strMethod = "wilcoxon",
    vThreshold = c(0.1, NA)
  ))

  # double programming
  t1_6_input <- dfInput

  t1_6_transformed <- dfInput %>%
    qualification_transform_counts()

  t1_6_analyzed <- t1_6_transformed %>%
    qualification_analyze_wilcoxon()

  class(t1_6_analyzed) <- c("tbl_df", "tbl", "data.frame")
  names(t1_6_analyzed$Estimate) <- rep("difference in location", nrow(t1_6_analyzed))

  t1_6_flagged <- t1_6_analyzed %>%
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
    select(-median) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t1_6_summary <- t1_6_flagged %>%
    mutate(
      Assessment = "AE",
      Score = PValue
    ) %>%
    select(SiteID, N, Score, Flag, Assessment) %>%
    arrange(desc(abs(.data$Score))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t1_6 <- list("strFunctionName" = "AE_Assess()",
               "lParams" = list("dfInput" = "dfInput",
                                "vThreshold" = c("c", "0.1", "NA"),
                                "strMethod" = "wilcoxon"),
               "lTags" = list(Assessment = "AE"),
               "dfInput" = t1_6_input,
               "dfTransformed" = t1_6_transformed,
               "dfAnalyzed" = t1_6_analyzed,
               "dfFlagged" = t1_6_flagged,
               "dfSummary" = t1_6_summary)

  # compare results
  expect_equal(test1_6, t1_6)
})
