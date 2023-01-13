test_that("Query rate assessment can return a correctly assessed data frame for the poisson test grouped by the site variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::QueryRate_Map_Raw()

  test10_4 <- QueryRate_Assess(
    dfInput = dfInput,
    strMethod = "Poisson",
    strGroup = "Site",
    vThreshold = c(-6, -4, 4, 6)
  )

  # double programming
  t10_4_input <- dfInput

  t10_4_transformed <- dfInput %>%
    qualification_transform_counts(countCol = "Count",
                                   exposureCol = "DataPoint")

  t10_4_analyzed <- t10_4_transformed %>%
    qualification_analyze_poisson()

  class(t10_4_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t10_4_flagged <- t10_4_analyzed %>%
    qualification_flag_poisson(threshold = c(-6, -4, 4, 6))

  t10_4_summary <- t10_4_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t10_4 <- list(
    "dfTransformed" = t10_4_transformed,
    "dfAnalyzed" = t10_4_analyzed,
    "dfFlagged" = t10_4_flagged,
    "dfSummary" = t10_4_summary
  )

  # compare results
  expect_equal(test10_4$lData[names(test10_4$lData) != "dfBounds"], t10_4)
})
