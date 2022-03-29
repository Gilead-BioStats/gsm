test_that("PD assessment can return a correctly assessed data frame for the wilcoxon test grouped by the study variable and the results should be flagged correctly when done in an iterative loop", {
  deviations_of_interest <- c("Informed Consent",
                              "Nonadherence of study drug",
                              "Assessments or procedures",
                              "Incorrect dispensing of study drug")

  test2_6 <- list()
  t2_6  <- list()

  for(type in deviations_of_interest){
    dfInput <- suppressWarnings(
      PD_Map_Raw(dfPD = clindata::raw_protdev %>% filter(DEVTYPE == type & SUBJID != ""),
                 dfRDSL = clindata::rawplus_rdsl %>% filter(!is.na(TimeOnTreatment))))

    # gsm
    test2_6 <- c(test2_6,
                 type = PD_Assess(dfInput,
                                  strMethod = "wilcoxon"))

    # Double Programming
    t2_6_input <- dfInput

    t2_6_transformed <- dfInput %>%
      qualification_transform_counts()

    t2_6_analyzed <- t2_6_transformed %>%
      qualification_analyze_wilcoxon()

    class(t2_6_analyzed) <- c("tbl_df", "tbl", "data.frame")
    names(t2_6_analyzed$Estimate) <- rep("difference in location", nrow(t2_6_analyzed))

    t2_6_flagged <- t2_6_analyzed %>%
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

    t2_6_summary <- t2_6_flagged %>%
      mutate(
        Assessment = "PD",
        Score = PValue
      ) %>%
      select(SiteID, N, Score, Flag, Assessment) %>%
      arrange(desc(abs(Score))) %>%
      arrange(match(Flag, c(1, -1, 0)))

    t2_6 <- c(t2_6,
              type = list("strFunctionName" = "PD_Assess()",
                          "lParams" = list("dfInput" = "dfInput",
                                           "strMethod" = "wilcoxon"),
                          "lTags" = list(Assessment = "PD"),
                          "dfInput" = t2_6_input,
                          "dfTransformed" = t2_6_transformed,
                          "dfAnalyzed" = t2_6_analyzed,
                          "dfFlagged" = t2_6_flagged,
                          "dfSummary" = t2_6_summary))

  }

  # compare results
  expect_equal(test2_6, t2_6)
})
