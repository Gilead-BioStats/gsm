test_that("AE assessment can return a correctly assessed data frame for the poisson test grouped by the study variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Raw(
    dfAE = clindata::raw_ae %>% filter(SUBJID != ""),
    dfRDSL = clindata::rawplus_rdsl %>% filter(!is.na(TimeOnTreatment))
  )

  test1_2 <- suppressWarnings(AE_Assess(
    dfInput = dfInput,
    strMethod = "poisson",
    vThreshold = c(-3,3)
  ))

  # Double Programming
  t1_2_input <- dfInput

  t1_2_transformed <- dfInput %>%
    qualification_transform_counts()

  t1_2_analyzed <- t1_2_transformed %>%
    qualification_analyze_poisson()

  class(t1_2_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t1_2_flagged <- t1_2_analyzed %>%
    mutate(
      ThresholdLow = -3,
      ThresholdHigh = 3,
      ThresholdCol = "Residuals",
      Flag = case_when(
        Residuals < -3 ~ -1,
        Residuals > 3 ~ 1,
        is.na(Residuals) ~ NA_real_,
        is.nan(Residuals) ~ NA_real_,
        TRUE ~ 0),
    ) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t1_2_summary <- t1_2_flagged %>%
    mutate(
      Assessment = "Safety",
      Label = "",
      Score = Residuals
    ) %>%
    select(Assessment, Label, SiteID, N, Score, Flag) %>%
    arrange(desc(abs(Score))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t1_2 <- list("strFunctionName" = "AE_Assess()",
               "lParams" = list("dfInput" = "dfInput",
                                "vThreshold" = c("c", "-3", "3"),
                                "strMethod" = "poisson"),
               "dfInput" = t1_2_input,
               "dfTransformed" = t1_2_transformed,
               "dfAnalyzed" = t1_2_analyzed,
               "dfFlagged" = t1_2_flagged,
               "dfSummary" = t1_2_summary)

  # compare results
  expect_equal(test1_2, t1_2)
})
