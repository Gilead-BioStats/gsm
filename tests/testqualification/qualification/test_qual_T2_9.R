test_that("PD assessment can return a correctly assessed data frame for the normal approximation test grouped by the study variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw()

  test2_9 <- PD_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "Study",
    vThreshold = c(-2, -1, 1, 2)
  )

  # Double Programming
  t2_9_input <- dfInput

  t2_9_transformed <- dfInput %>%
    qualification_transform_counts(
      GroupID = "StudyID"
    )

  t2_9_analyzed <- t2_9_transformed %>%
    qualification_analyze_normalapprox(strType = "rate")

  class(t2_9_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t2_9_flagged <- t2_9_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))

  t2_9_summary <- t2_9_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t2_9 <- list(
    "dfTransformed" = t2_9_transformed,
    "dfAnalyzed" = t2_9_analyzed,
    "dfFlagged" = t2_9_flagged,
    "dfSummary" = t2_9_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test2_9$lData[names(test2_9$lData) != "dfBounds"], t2_9)
})
