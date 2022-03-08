test_that("Test that Assessment can return all data in the standard data pipeline (`dfInput`, `dfTransformed`, `dfAnalyzed`, `dfFlagged`, and `dfSummary`) for a wilcoxon test", {
  dfInput <- gsm::AE_Map_Raw(
    dfAE = clindata::raw_ae,
    dfRDSL = clindata::rawplus_rdsl
  )

  # gsm data
  test_6 <- suppressWarnings(AE_Assess(
    dfInput = dfInput,
    strMethod = "wilcoxon",
    bDataList = TRUE
  ))

  # double programming
  t6_input <- dfInput

  t6_transformed <- dfInput %>%
    qualification_transform_counts()

  t6_analyzed <- t6_transformed %>%
    qualification_analyze_wilcoxon()

  class(t6_analyzed) <- c("tbl_df", "tbl", "data.frame")
  names(t6_analyzed$Estimate) <- rep("difference in location", nrow(t6_analyzed))

  t6_flagged <- t6_analyzed %>%
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
    select(-median)

  t6_summary <- t6_flagged %>%
    mutate(
      Assessment = "Safety",
      Label = "",
      Score = PValue
    ) %>%
    select(Assessment, Label, SiteID, N, Score, Flag)

  t6 <- list("dfInput" = t6_input,
             "dfTransformed" = t6_transformed,
             "dfAnalyzed" = t6_analyzed,
             "dfFlagged" = t6_flagged,
             "dfSummary" = t6_summary)

  expect_equal(test_6, t6)
})
