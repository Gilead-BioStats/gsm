test_that("PD assessment can return a correctly assessed data frame for the poisson test grouped by the study variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw(
    dfPD = clindata::raw_protdev,
    dfRDSL = clindata::rawplus_rdsl
  )

  test2_1 <- suppressWarnings(PD_Assess(
    dfInput = dfInput,
    strMethod = "poisson",
    vThreshold = c(-3,3)
  ))

  # Double Programming
  t2_1_input <- dfInput

  t2_1_transformed <- dfInput %>%
    qualification_transform_counts()

  t2_1_analyzed <- t2_1_transformed %>%
    qualification_analyze_poisson()

  class(t2_1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t2_1_flagged <- t2_1_analyzed %>%
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
    )

  t2_1_summary <- t2_1_flagged %>%
    mutate(
      Assessment = "Safety",
      Label = "",
      Score = Residuals
    ) %>%
    select(Assessment, Label, SiteID, N, Score, Flag)

  t2_1 <- list("strFunctionName" = "PD_Assess()",
               "lParams" = list("dfInput" = "dfInput",
                                "vThreshold" = c("c", "-3", "3"),
                                "strMethod" = "poisson"),
               "dfInput" = t2_1_input,
               "dfTransformed" = t2_1_transformed,
               "dfAnalyzed" = t2_1_analyzed,
               "dfFlagged" = t2_1_flagged,
               "dfSummary" = t2_1_summary)

  # compare results
  expect_equal(test2_1, t2_1)
})
