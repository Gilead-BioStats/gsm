test_that("PD assessment can return a correctly assessed data frame for the normal approximation test grouped by the study variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Binary()

  test23_9 <- PD_Assess_Binary(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "Study",
    vThreshold = c(-2, -1, 1, 2)
  )

  # Double Programming
  t23_9_input <- dfInput

  t23_9_transformed <- dfInput %>%
    qualification_transform_counts(
      GroupID = "StudyID",
      exposureCol = "Total"
    )

  t23_9_analyzed <- t23_9_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t23_9_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t23_9_flagged <- t23_9_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))

  t23_9_summary <- t23_9_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t23_9 <- list(
    "dfTransformed" = t23_9_transformed,
    "dfAnalyzed" = t23_9_analyzed,
    "dfFlagged" = t23_9_flagged,
    "dfSummary" = t23_9_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test23_9$lData[names(test23_9$lData) != "dfBounds"], t23_9)
})
