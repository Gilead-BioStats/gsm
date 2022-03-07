test_that("AE assessment can return a correctly assessed data frame for the poisson test grouped by the study variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Raw(
    dfAE = clindata::raw_ae,
    dfRDSL = clindata::rawplus_rdsl
  )

  test_2 <- suppressWarnings(AE_Assess(
    dfInput = dfInput,
    strMethod = "poisson",
    vThreshold = c(-3,3)
  ))

  # Double Programming
  t2 <- dfInput %>%
    qualification_transform_counts() %>%
    qualification_analyze_poisson() %>%
    mutate(
      Score = Residuals,
      Flag = case_when(
        Score < -3 ~ -1,
        Score > 3 ~ 1,
        is.na(Score) ~ NA_real_,
        is.nan(Score) ~ NA_real_,
        TRUE ~ 0),
      Assessment = "Safety",
      Label = "") %>%
    select("Assessment", "Label", "SiteID", "N", "Score", "Flag" )

  # set classes lost in analyze
  class(t2) <- c("tbl_df", "tbl", "data.frame")

  # compare results
  expect_equal(test_2, t2)
})
