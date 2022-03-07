test_that("AE assessment can return a correctly assessed data frame for the wilcoxon test grouped by the study variable when given correct input data from safetyData and the results should be flagged correctly.", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Adam(
    dfADSL = safetyData::adam_adsl,
    dfADAE = safetyData::adam_adae
  )

  test_3 <- AE_Assess(
    dfInput = dfInput,
    strMethod = "wilcoxon"
  )

  # Double Programming
  t3 <- dfInput %>%
    qualification_transform_counts() %>%
    qualification_analyze_wilcoxon() %>%
    mutate(
      Score = PValue,
      Flag = case_when(
        Score < 0.0001 ~ -1,
        is.na(Score) ~ NA_real_,
        is.nan(Score) ~ NA_real_,
        TRUE ~ 0),
      Assessment = "Safety",
      Label = "") %>%
    mutate(
      median = median(Estimate),
      Flag = case_when(
        Flag != 0 & Estimate < median ~ -1,
        Flag != 0 & Estimate >= median ~ 1,
        TRUE ~ Flag
      )) %>%
    select("Assessment", "Label", "SiteID", "N", "Score", "Flag" )

  # set classes lost in analyze
  class(t3) <- c("tbl_df", "tbl", "data.frame")

  # compare results
  expect_equal(test_3, t3)

})
