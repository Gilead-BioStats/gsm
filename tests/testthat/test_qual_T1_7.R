test_that("AE assessment can return a correctly assessed data frame for the wilcoxon test grouped by the study variable when given subset input data from clindata and the results should be flagged correctly.", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Raw(dfs = list(
    dfAE = clindata::rawplus_ae %>% filter(AE_SERIOUS == "Yes"),
    dfSUBJ = clindata::rawplus_subj
  ))

  test1_7 <- AE_Assess(
    dfInput = dfInput,
    strMethod = "wilcoxon",
    bChart = FALSE
  )

  # double programming
  t1_7_input <- dfInput

  t1_7_transformed <- dfInput %>%
    qualification_transform_counts()

  t1_7_analyzed <- t1_7_transformed %>%
    qualification_analyze_wilcoxon()

  class(t1_7_analyzed) <- c("tbl_df", "tbl", "data.frame")
  names(t1_7_analyzed$Estimate) <- rep("difference in location", nrow(t1_7_analyzed))

  t1_7_flagged <- t1_7_analyzed %>%
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
    select(-median) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t1_7_summary <- t1_7_flagged %>%
    mutate(
      Assessment = "AE",
      Score = PValue
    ) %>%
    select(SiteID, N, Score, Flag, Assessment) %>%
    arrange(desc(abs(.data$Score))) %>%
    arrange(match(Flag, c(1, -1, 0)))


  t1_7 <- list("strFunctionName" = "AE_Assess()",
             "lParams" = list("dfInput" = "dfInput",
                              "strMethod" = "wilcoxon",
                              "bChart" = "FALSE"),
             "lTags" = list(Assessment = "AE"),
             "dfInput" = t1_7_input,
             "dfTransformed" = t1_7_transformed,
             "dfAnalyzed" = t1_7_analyzed,
             "dfFlagged" = t1_7_flagged,
             "dfSummary" = t1_7_summary)

  # compare results
  expect_equal(test1_7, t1_7)

})
