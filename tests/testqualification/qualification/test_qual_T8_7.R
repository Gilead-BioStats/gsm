test_that("Data entry assessment can return a correctly assessed data frame for the normal approximation test grouped by the site variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::DataEntry_Map_Raw()

  test8_7 <- DataEntry_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "Site",
    vThreshold = c(-2, -1, 1, 2)
  )

  # double programming
  t8_7_input <- dfInput

  t8_7_transformed <- dfInput %>%
    qualification_transform_counts(countCol = "Count",
                                   exposureCol = "Total")

  t8_7_analyzed <- t8_7_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t8_7_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t8_7_flagged <- t8_7_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))

  t8_7_summary <- t8_7_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t8_7 <- list(
    "dfTransformed" = t8_7_transformed,
    "dfAnalyzed" = t8_7_analyzed,
    "dfFlagged" = t8_7_flagged,
    "dfSummary" = t8_7_summary
  )

  # compare results
  expect_equal(test8_7$lData[names(test8_7$lData) != "dfBounds"], t8_7)
})
