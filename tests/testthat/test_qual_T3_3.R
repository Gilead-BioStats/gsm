test_that("IE assessment can return a correctly assessed data frame grouped by the study variableand the results should be flagged correctly when done in an iterative loop", {
  test3_3 <- list()
  t3_3  <- list()

  for(protocol in unique(clindata::raw_ie_all$PROTVER_STD)){
    dfInput <- suppressWarnings(IE_Map_Raw(
      clindata::raw_ie_all %>% dplyr::filter(SUBJID != "" & PROTVER_STD == protocol),
      clindata::rawplus_rdsl,
      vCategoryValues= c("EXCL","INCL"),
      vExpectedResultValues=c(0,1)
    ))

    # gsm
    test3_3 <- c(test3_3,
                 protocol = suppressWarnings(IE_Assess(
                   dfInput = dfInput,
                 )))

    # Double Programming
    t3_3_input <- dfInput

    t3_3_transformed <- dfInput %>%
      qualification_transform_counts(exposureCol = NA)

    t3_3_analyzed <- t3_3_transformed %>%
      mutate(Estimate = TotalCount)

    class(t3_3_analyzed) <- c("tbl_df", "tbl", "data.frame")

    t3_3_flagged <- t3_3_analyzed %>%
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

    t3_3_summary <- t3_3_flagged %>%
      mutate(
        Assessment = "IE",
        Score = Estimate
      ) %>%
      select(SiteID, N, Score, Flag, Assessment) %>%
      arrange(desc(abs(Score))) %>%
      arrange(match(Flag, c(1, -1, 0)))

    t3_3 <- c(t3_3,
              protocol = list("strFunctionName" = "IE_Assess()",
                              "lParams" = list("dfInput" = "dfInput"),
                              "lTags" = list(Assessment = "IE"),
                              "dfInput" = t3_3_input,
                              "dfTransformed" = t3_3_transformed,
                              "dfAnalyzed" = t3_3_analyzed,
                              "dfFlagged" = t3_3_flagged,
                              "dfSummary" = t3_3_summary))
  }

  # compare results
  expect_equal(test3_3, t3_3)
})
