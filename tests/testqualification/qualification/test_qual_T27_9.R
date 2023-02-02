test_that("PD assessment can return a correctly assessed data frame for the normal approximation test grouped by the study variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Binary()

  test27_9 <- PD_Assess_Binary(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "Study",
    vThreshold = c(-2, -1, 1, 2)
  )

  # Double Programming
  t27_9_input <- dfInput

  t27_9_transformed <- dfInput %>%
    qualification_transform_counts(
      GroupID = "StudyID",
      exposureCol = "Total"
    )

  t27_9_analyzed <- t27_9_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t27_9_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t27_9_flagged <- t27_9_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))

  t27_9_summary <- t27_9_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t27_9 <- list(
    "dfTransformed" = t27_9_transformed,
    "dfAnalyzed" = t27_9_analyzed,
    "dfFlagged" = t27_9_flagged,
    "dfSummary" = t27_9_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test27_9$lData[names(test27_9$lData) != "dfBounds"], t27_9)
})
