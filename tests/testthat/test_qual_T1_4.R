test_that("AE assessment can return a correctly assessed data frame for the wilcoxon test grouped by the study variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Raw(
    dfAE = clindata::raw_ae,
    dfRDSL = clindata::rawplus_rdsl
  )

  test_4 <- suppressWarnings(AE_Assess(
    dfInput = dfInput,
    strMethod = "wilcoxon",
    vThreshold = c(.1, NA)
  ))

  # Double Programming
  t4 <- dfInput %>%
    qualification_transform_counts() %>%
    qualification_analyze_wilcoxon() %>%
    mutate(
      Score = PValue,
      Flag = case_when(
        Score < 0.1 ~ -1,
        is.na(Score) ~ NA_real_,
        is.nan(Score) ~ NA_real_,
        TRUE ~ 0
      ),
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
  class(t4) <- c("tbl_df", "tbl", "data.frame")

  # compare results
  expect_equal(test_4, t4)
})
