test_that("AE assessment can return a correctly assessed data frame for the poisson test grouped by the study variable  when given subset input data from clindata and the results should be flagged correctly.", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Raw()

  test1_3 <- AE_Assess(
    dfInput = dfInput,
    strMethod = "poisson",
    bChart = FALSE
  )

  # Double Programming
  t1_3_input <- dfInput

  t1_3_transformed <- dfInput %>%
    qualification_transform_counts()

  t1_3_analyzed <- t1_3_transformed %>%
    qualification_analyze_poisson()

  class(t1_3_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t1_3_flagged <- t1_3_analyzed %>%
    mutate(
      ThresholdLow = -5,
      ThresholdHigh = 5,
      ThresholdCol = "Residuals",
      Flag = case_when(
        Residuals < -5 ~ -1,
        Residuals > 5 ~ 1,
        is.na(Residuals) ~ NA_real_,
        is.nan(Residuals) ~ NA_real_,
        TRUE ~ 0
      ),
    ) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t1_3_summary <- t1_3_flagged %>%
    mutate(
      Assessment = "AE",
      Score = Residuals
    ) %>%
    select(SiteID, N, Score, Flag, Assessment) %>%
    arrange(desc(abs(.data$Score))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t1_3 <- list(
    "strFunctionName" = "AE_Assess()",
    "lParams" = list(
      "dfInput" = "dfInput",
      "strMethod" = "poisson",
      "bChart" = "FALSE"
    ),
    "lTags" = list(Assessment = "AE"),
    "dfInput" = t1_3_input,
    "dfTransformed" = t1_3_transformed,
    "dfAnalyzed" = t1_3_analyzed,
    "dfFlagged" = t1_3_flagged,
    "dfSummary" = t1_3_summary
  )

  # compare results
  expect_equal(test1_3, t1_3)
})
