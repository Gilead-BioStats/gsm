test_that("PD assessment can return a correctly assessed data frame for the wilcoxon test grouped by the study variable when given subset input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw(
    dfPD = filter(clindata::raw_protdev, DEVUSED %in% c("Y", "y")),
    dfRDSL = clindata::rawplus_rdsl %>% filter(!is.na(TimeOnTreatment))
  )

  test2_5 <- suppressWarnings(PD_Assess(
    dfInput = dfInput,
    strMethod = "wilcoxon"
  ))

  # double programming
  t2_5_input <- dfInput

  t2_5_transformed <- dfInput %>%
    qualification_transform_counts()

  t2_5_analyzed <- t2_5_transformed %>%
    qualification_analyze_wilcoxon()

  class(t2_5_analyzed) <- c("tbl_df", "tbl", "data.frame")
  names(t2_5_analyzed$Estimate) <- rep("difference in location", nrow(t2_5_analyzed))

  t2_5_flagged <- t2_5_analyzed %>%
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

  t2_5_summary <- t2_5_flagged %>%
    mutate(
      Assessment = "Safety",
      Label = "",
      Score = PValue
    ) %>%
    select(Assessment, Label, SiteID, N, Score, Flag) %>%
    arrange(desc(abs(Score))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t2_5 <- list("strFunctionName" = "PD_Assess()",
               "lParams" = list("dfInput" = "dfInput",
                                "strMethod" = "wilcoxon"),
               "dfInput" = t2_5_input,
               "dfTransformed" = t2_5_transformed,
               "dfAnalyzed" = t2_5_analyzed,
               "dfFlagged" = t2_5_flagged,
               "dfSummary" = t2_5_summary)

  # compare results
  expect_equal(test2_5, t2_5)
})
