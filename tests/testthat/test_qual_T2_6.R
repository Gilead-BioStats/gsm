test_that("PD assessment can return a correctly assessed data frame for the wilcoxon test grouped by the study variable and the results should be flagged correctly when done in an iterative loop", {
  test2_6_assess <- vector("list", length(unique(clindata::raw_protdev$DEVTYPE)))
  t2_6_assess  <- vector("list", length(unique(clindata::raw_protdev$DEVTYPE)))

  names(test2_6_assess) <- unique(clindata::raw_protdev$DEVTYPE)
  names(t2_6_assess) <- unique(clindata::raw_protdev$DEVTYPE)

  for(type in unique(clindata::raw_protdev$DEVTYPE)){
    dfInput <- PD_Map_Raw(dfPD = filter(clindata::raw_protdev, DEVTYPE == type),
                          dfRDSL = clindata::rawplus_rdsl)

    # gsm
    test2_6_assess[type] <- PD_Assess(dfInput,
                                      strMethod = "wilcoxon")


    # Double Programming
    t2_6_input <- dfInput

    t2_6_transformed <- dfInput %>%
      qualification_transform_counts()

    t2_6_analyzed <- t2_6_transformed %>%
      qualification_analyze_wilcoxon()

    class(t2_6_analyzed) <- c("tbl_df", "tbl", "data.frame")

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
        Assessment = "Safety",
        Label = "",
        Score = PValue
      ) %>%
      select(Assessment, Label, SiteID, N, Score, Flag) %>%
      arrange(desc(abs(Score))) %>%
      arrange(match(Flag, c(1, -1, 0)))

    t2_6_assess[type] <- list("strFunctionName" = "PD_Assess()",
                              "lParams" = list("dfInput" = "dfInput",
                                               "strMethod" = "wilcoxon"),
                              "dfInput" = t2_6_input,
                              "dfTransformed" = t2_6_transformed,
                              "dfAnalyzed" = t2_6_analyzed,
                              "dfFlagged" = t2_6_flagged,
                              "dfSummary" = t2_6_summary)

  }

  test2_6 <- test2_6_assess$dfSummary %>% bind_rows()
  t2_6 <- t2_6_assess$dfSummary %>% bind_rows()

  # compare results
  expect_equal(test2_6, t2_6)
})
