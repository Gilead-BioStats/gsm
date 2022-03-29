test_that("Consent assessment can return a correctly assessed data frame grouped by the study variable when given correct input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- suppressWarnings(Consent_Map_Raw(
    clindata::raw_consent %>% filter(SUBJID != ""),
    clindata::rawplus_rdsl,
    strConsentTypeValue = "BIOM"
  ))

  test4_1 <- suppressWarnings(Consent_Assess(
    dfInput = dfInput,
  ))

  # Double Programming
  t4_1_input <- dfInput

  t4_1_transformed <- dfInput %>%
    qualification_transform_counts(exposureCol = NA)

  t4_1_analyzed <- t4_1_transformed %>%
    mutate(Estimate = TotalCount)

  class(t4_1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t4_1_flagged <- t4_1_analyzed %>%
    mutate(
      ThresholdLow = NA_real_,
      ThresholdHigh = 0.5,
      ThresholdCol = "Estimate",
      Flag = case_when(
        Estimate > 0.5 ~ 1,
        is.na(Estimate) ~ NA_real_,
        is.nan(Estimate) ~ NA_real_,
        TRUE ~ 0),
    ) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t4_1_summary <- t4_1_flagged %>%
    mutate(
      Assessment = "Consent",
      Score = Estimate
    ) %>%
    select(SiteID, N, Score, Flag, Assessment) %>%
    arrange(desc(abs(Score))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t4_1 <- list("strFunctionName" = "Consent_Assess()",
               "lParams" = list("dfInput" = "dfInput"),
               "lTags" = list(Assessment = "Consent"),
               "dfInput" = t4_1_input,
               "dfTransformed" = t4_1_transformed,
               "dfAnalyzed" = t4_1_analyzed,
               "dfFlagged" = t4_1_flagged,
               "dfSummary" = t4_1_summary)

  # compare results
  expect_equal(test4_1, t4_1)
})
