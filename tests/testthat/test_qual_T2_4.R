test_that("AE assessment can return a correctly assessed data frame for the wilcoxon test grouped by the study variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw()

  test2_4 <- PD_Assess(
    dfInput = dfInput,
    strMethod = "wilcoxon",
    vThreshold = c(0.1, NA),
    bChart = FALSE
  )

  # double programming
  t2_4_input <- dfInput

  t2_4_transformed <- dfInput %>%
    qualification_transform_counts()

  t2_4_analyzed <- t2_4_transformed %>%
    qualification_analyze_wilcoxon()

  class(t2_4_analyzed) <- c("tbl_df", "tbl", "data.frame")
  names(t2_4_analyzed$Estimate) <- rep("difference in location", nrow(t2_4_analyzed))

  t2_4_flagged <- t2_4_analyzed %>%
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
        Flag != 0 & Estimate >= median ~ 1,
        Flag != 0 & Estimate < median ~ -1,
        TRUE ~ Flag)
    ) %>%
    select(-median) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t2_4_summary <- t2_4_flagged %>%
    mutate(
      Assessment = "PD",
      Score = PValue
    ) %>%
    select(SiteID, N, Score, Flag, Assessment) %>%
    arrange(desc(abs(Score))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t2_4 <- list("strFunctionName" = "PD_Assess()",
               "lParams" = list("dfInput" = "dfInput",
                                "vThreshold" = c("c", "0.1", "NA"),
                                "strMethod" = "wilcoxon",
                                "bChart" = "FALSE"),
               "lTags" = list(Assessment = "PD"),
               "dfInput" = t2_4_input,
               "dfTransformed" = t2_4_transformed,
               "dfAnalyzed" = t2_4_analyzed,
               "dfFlagged" = t2_4_flagged,
               "dfSummary" = t2_4_summary)

  # compare results
  expect_equal(test2_4, t2_4)
})
