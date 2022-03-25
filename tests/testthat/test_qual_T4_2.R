test_that("Consent assessment can return a correctly assessed data frame grouped by the study variable when given correct input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- suppressWarnings(Consent_Map_Raw(
    clindata::raw_consent %>% filter(SUBJID != ""),
    clindata::rawplus_rdsl,
    strConsentTypeValue = "BIOM"
  ))

  test4_2 <- suppressWarnings(Consent_Assess(
    dfInput = dfInput,
  ))

  # Double Programming
  t4_2_input <- dfInput

  t4_2_transformed <- dfInput %>%
    qualification_transform_counts(exposureCol = NA)

  t4_2_analyzed <- t4_2_transformed %>%
    mutate(Estimate = TotalCount)

  class(t4_2_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t4_2_flagged <- t4_2_analyzed %>%
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

  t4_2_summary <- t4_2_flagged %>%
    mutate(
      Assessment = "Consent",
      Score = Estimate
    ) %>%
    select(SiteID, N, Score, Flag, Assessment) %>%
    arrange(desc(abs(Score))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t4_2 <- list("strFunctionName" = "Consent_Assess()",
               "lParams" = list("dfInput" = "dfInput"),
               "lTags" = list(Assessment = "Consent"),
               "dfInput" = t4_2_input,
               "dfTransformed" = t4_2_transformed,
               "dfAnalyzed" = t4_2_analyzed,
               "dfFlagged" = t4_2_flagged,
               "dfSummary" = t4_2_summary)

  # compare results
  expect_equal(test4_2, t4_2)
})
