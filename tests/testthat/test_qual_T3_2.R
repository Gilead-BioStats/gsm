test_that("IE assessment can return a correctly assessed data frame grouped by the study variable when given subset input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- suppressWarnings(IE_Map_Raw(
    clindata::raw_ie_all %>% dplyr::filter(SUBJID != "" & PROTVER_STD == "A1"),
    clindata::rawplus_rdsl,
    vCategoryValues= c("EXCL","INCL"),
    vExpectedResultValues=c(0,1)
  ))

  test3_1 <- suppressWarnings(IE_Assess(
    dfInput = dfInput,
  ))

  # Double Programming
  t3_1_input <- dfInput

  t3_1_transformed <- dfInput %>%
    qualification_transform_counts(exposureCol = NA)

  t3_1_analyzed <- t3_1_transformed %>%
    mutate(Estimate = TotalCount)

  class(t3_1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t3_1_flagged <- t3_1_analyzed %>%
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

  t3_1_summary <- t3_1_flagged %>%
    mutate(
      Assessment = "IE",
      Score = Estimate
    ) %>%
    select(SiteID, N, Score, Flag, Assessment) %>%
    arrange(desc(abs(Score))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t3_1 <- list("strFunctionName" = "IE_Assess()",
               "lParams" = list("dfInput" = "dfInput"),
               "lTags" = list(Assessment = "IE"),
               "dfInput" = t3_1_input,
               "dfTransformed" = t3_1_transformed,
               "dfAnalyzed" = t3_1_analyzed,
               "dfFlagged" = t3_1_flagged,
               "dfSummary" = t3_1_summary)

  # compare results
  expect_equal(test3_1, t3_1)
})
