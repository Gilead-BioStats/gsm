test_that("AE assessment can return a correctly assessed data frame for the poisson test grouped by the study variable when given correct input data from safetyData and the results should be flagged correctly.", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Adam(
    dfADSL = safetyData::adam_adsl,
    dfADAE = safetyData::adam_adae
  )

  test_1 <- AE_Assess(
    dfInput = dfInput,
    strMethod = "poisson"
  )

  # Double Programming
  t1 <- dfInput %>%
    qualification_transform_counts() %>%
    qualification_analyze_poisson() %>%
    mutate(
      Score = Residuals,
      Flag = case_when(
        Score < -5 ~ -1,
        Score > 5 ~ 1,
        is.na(Score) ~ NA_real_,
        is.nan(Score) ~ NA_real_,
        TRUE ~ 0),
      Assessment = "Safety",
      Label = "") %>%
    select("Assessment", "Label", "SiteID", "N", "Score", "Flag" )

  # set classes lost in analyze
  class(t1) <- c("tbl_df", "tbl", "data.frame")

  # compare results
  expect_equal(test_1, t1)
})
