test_that("Test that Assessment can return all data in the standard data pipeline (`dfInput`, `dfTransformed`, `dfAnalyzed`, `dfFlagged`, and `dfSummary`) for a poisson test", {
  dfInput <- gsm::AE_Map_Raw(
    dfAE = clindata::raw_ae,
    dfRDSL = clindata::rawplus_rdsl
  )

  # gsm data
  test_5 <- suppressWarnings(AE_Assess(
    dfInput = dfInput,
    bDataList = TRUE
  ))

  # double programming
  t5_input <- dfInput

  t5_transformed <- dfInput %>%
    qualification_transform_counts()

  t5_analyzed <- t5_transformed %>%
    qualification_analyze_poisson()

  class(t5_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_flagged <- t5_analyzed %>%
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
    )

  t5_summary <- t5_flagged %>%
    mutate(
      Assessment = "Safety",
      Label = "",
      Score = Residuals
    ) %>%
    select(Assessment, Label, SiteID, N, Score, Flag)

  t5 <- list("dfInput" = t5_input,
             "dfTransformed" = t5_transformed,
             "dfAnalyzed" = t5_analyzed,
             "dfFlagged" = t5_flagged,
             "dfSummary" = t5_summary)

  expect_equal(test_5, t5)
})
