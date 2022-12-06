test_that("PD assessment can return a correctly assessed data frame for the poisson test grouped by the study variable and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw()

  test2_3 <- PD_Assess(
    dfInput = dfInput,
    strMethod = "Poisson",
    strGroup = "Study"
  )

  # Double Programming
  t2_3_input <- dfInput

  t2_3_transformed <- dfInput %>%
    qualification_transform_counts(GroupID = "StudyID")

  t2_3_analyzed <- t2_3_transformed %>%
    qualification_analyze_poisson()

  class(t2_3_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t2_3_flagged <- t2_3_analyzed %>%
    qualification_flag_poisson()

  t2_3_summary <- t2_3_flagged %>%
    select(GroupID, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t2_3 <- list(
    "dfTransformed" = t2_3_transformed,
    "dfAnalyzed" = t2_3_analyzed,
    "dfFlagged" = t2_3_flagged,
    "dfSummary" = t2_3_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test2_3$lData[names(test2_3$lData) != "dfBounds"], t2_3)
})
