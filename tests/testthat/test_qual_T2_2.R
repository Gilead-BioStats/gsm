test_that("PD assessment can return a correctly assessed data frame for the poisson test grouped by the study variable when given subset input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- suppressWarnings(gsm::PD_Map_Raw(
    dfPD = clindata::raw_protdev %>%  filter(SUBJID != "" & DEVUSED %in% c("Y", "y")),
    dfRDSL = clindata::rawplus_rdsl %>% filter(!is.na(TimeOnTreatment))
  ))

  test2_2 <- suppressWarnings(PD_Assess(
    dfInput = dfInput,
    strMethod = "poisson"
  ))

  # Double Programming
  t2_2_input <- dfInput

  t2_2_transformed <- dfInput %>%
    qualification_transform_counts()

  t2_2_analyzed <- t2_2_transformed %>%
    qualification_analyze_poisson()

  class(t2_2_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t2_2_flagged <- t2_2_analyzed %>%
    mutate(
      ThresholdLow = -5,
      ThresholdHigh = 5,
      ThresholdCol = "Residuals",
      Flag = case_when(
        Residuals < -5 ~ -1,
        Residuals > 5 ~ 1,
        is.na(Residuals) ~ NA_real_,
        is.nan(Residuals) ~ NA_real_,
        TRUE ~ 0),
    ) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t2_2_summary <- t2_2_flagged %>%
    mutate(
      Assessment = "PD",
      Score = Residuals
    ) %>%
    select(SiteID, N, Score, Flag, Assessment) %>%
    arrange(desc(abs(Score))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t2_2 <- list("strFunctionName" = "PD_Assess()",
               "lParams" = list("dfInput" = "dfInput",
                                "strMethod" = "poisson"),
               "lTags" = list(Assessment = "PD"),
               "dfInput" = t2_2_input,
               "dfTransformed" = t2_2_transformed,
               "dfAnalyzed" = t2_2_analyzed,
               "dfFlagged" = t2_2_flagged,
               "dfSummary" = t2_2_summary)

  # compare results
  expect_equal(test2_2, t2_2)
})
