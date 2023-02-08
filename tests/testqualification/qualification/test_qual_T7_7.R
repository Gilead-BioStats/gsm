test_that("Data change assessment can return a correctly assessed data frame for the normal approximation test grouped by the site variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::DataChg_Map_Raw()

  test7_7 <- DataChg_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "Site",
    vThreshold = c(-2, -1, 1, 2)
  )

  # double programming
  t7_7_input <- dfInput

  t7_7_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total"
    )

  t7_7_analyzed <- t7_7_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t7_7_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t7_7_flagged <- t7_7_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))

  t7_7_summary <- t7_7_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t7_7 <- list(
    "dfTransformed" = t7_7_transformed,
    "dfAnalyzed" = t7_7_analyzed,
    "dfFlagged" = t7_7_flagged,
    "dfSummary" = t7_7_summary
  )

  # compare results
  expect_equal(test7_7$lData[names(test7_7$lData) != "dfBounds"], t7_7)
})
