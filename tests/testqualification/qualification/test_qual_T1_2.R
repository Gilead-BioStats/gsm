test_that("AE assessment can return a correctly assessed data frame for the poisson test grouped by the study variable when given subset input data from clindata and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Raw(dfs = list(
    dfAE = clindata::rawplus_ae %>% filter(aeser_std_nsv == "Y"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test1_2 <- AE_Assess(
    dfInput = dfInput,
    strMethod = "Poisson",
    vThreshold = c(-3, -1, 1, 3),
    strGroup = "Study"
  )

  # Double Programming
  t1_2_input <- dfInput

  t1_2_transformed <- dfInput %>%
    qualification_transform_counts(
      GroupID = "StudyID"
    )

  t1_2_analyzed <- t1_2_transformed %>%
    qualification_analyze_poisson()

  class(t1_2_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t1_2_flagged <- t1_2_analyzed %>%
    qualification_flag_poisson(threshold = c(-3, -1, 1, 3))

  t1_2_summary <- t1_2_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t1_2 <- list(
    "dfTransformed" = t1_2_transformed,
    "dfAnalyzed" = t1_2_analyzed,
    "dfFlagged" = t1_2_flagged,
    "dfSummary" = t1_2_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test1_2$lData[names(test1_2$lData) != "dfBounds"], t1_2)
})
