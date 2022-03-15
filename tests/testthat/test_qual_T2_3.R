test_that("PD assessment can return a correctly assessed data frame for the poisson test grouped by the study variable and the results should be flagged correctly when done in an iterative loop", {
  test2_3_assess <- vector("list", length(unique(clindata::raw_protdev$DEVTYPE)))
  t2_3_assess  <- vector("list", length(unique(clindata::raw_protdev$DEVTYPE)))

  names(test2_3_assess) <- unique(clindata::raw_protdev$DEVTYPE)
  names(t2_3_assess) <- unique(clindata::raw_protdev$DEVTYPE)

  for(type in unique(clindata::raw_protdev$DEVTYPE)){
    dfInput <- PD_Map_Raw(dfPD = filter(clindata::raw_protdev, DEVTYPE == type),
                        dfRDSL = clindata::rawplus_rdsl)

    # gsm
    test2_3_assess[type] <- PD_Assess(dfInput)


    # Double Programming
    t2_3_input <- dfInput

    t2_3_transformed <- dfInput %>%
      qualification_transform_counts()

    t2_3_analyzed <- t2_3_transformed %>%
      qualification_analyze_poisson()

    class(t2_3_analyzed) <- c("tbl_df", "tbl", "data.frame")

    t2_3_flagged <- t2_3_analyzed %>%
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

    t2_3_summary <- t2_3_flagged %>%
      mutate(
        Assessment = "Safety",
        Label = "",
        Score = Residuals
      ) %>%
      select(Assessment, Label, SiteID, N, Score, Flag)

    t2_3_assess[type] <- list("strFunctionName" = "PD_Assess()",
                 "lParams" = list("dfInput" = "dfInput",
                                  "strMethod" = "poisson"),
                 "dfInput" = t2_3_input,
                 "dfTransformed" = t2_3_transformed,
                 "dfAnalyzed" = t2_3_analyzed,
                 "dfFlagged" = t2_3_flagged,
                 "dfSummary" = t2_3_summary)

  }

  test2_3 <- test2_3_assess$dfSummary %>% bind_rows()
  t2_3 <- t2_3_assess$dfSummary %>% bind_rows()

  # compare results
  expect_equal(test2_3, t2_3)
})
