test_that("AE assessment can return a correctly assessed data frame for the poisson test grouped by the study variable when given correct input data from safetyData and the results should be flagged correctly.", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Adam(
    dfADSL = safetyData::adam_adsl,
    dfADAE = safetyData::adam_adae
  )

  test1_1 <- AE_Assess(
    dfInput = dfInput,
    strMethod = "poisson"
  )

  # Double Programming
  t1_input <- dfInput

  t1_transformed <- dfInput %>%
    qualification_transform_counts()

  t1_analyzed <- t1_transformed %>%
    qualification_analyze_poisson()

  class(t1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t1_flagged <- t1_analyzed %>%
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

  t1_summary <- t1_flagged %>%
    mutate(
      Assessment = "Safety",
      Label = "",
      Score = Residuals
    ) %>%
    select(Assessment, Label, SiteID, N, Score, Flag)  %>%
    arrange(desc(abs(.data$Score))) %>%
    arrange(match(Flag, c(1, -1, 0)))


  t1_1 <- list("strFunctionName" = "AE_Assess()",
             "lParams" = list("dfInput" = "dfInput",
                              "strMethod" = "poisson"),
             "dfInput" = t1_input,
             "dfTransformed" = t1_transformed,
             "dfAnalyzed" = t1_analyzed,
             "dfFlagged" = t1_flagged,
             "dfSummary" = t1_summary)

  # compare results
  expect_equal(test1_1, t1_1)
})
