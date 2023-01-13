test_that("Query age assessment can return a correctly assessed data frame for the normal approximation test grouped by the site variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::QueryAge_Map_Raw()

  test9_7 <- QueryAge_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "Site",
    vThreshold = c(-2, -1, 1, 2)
  )

  # double programming
  t9_7_input <- dfInput

  t9_7_transformed <- dfInput %>%
    qualification_transform_counts(countCol = "Count",
                                   exposureCol = "Total")

  t9_7_analyzed <- t9_7_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t9_7_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t9_7_flagged <- t9_7_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))

  t9_7_summary <- t9_7_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t9_7 <- list(
    "dfTransformed" = t9_7_transformed,
    "dfAnalyzed" = t9_7_analyzed,
    "dfFlagged" = t9_7_flagged,
    "dfSummary" = t9_7_summary
  )

  # compare results
  expect_equal(test9_7$lData[names(test9_7$lData) != "dfBounds"], t9_7)
})
