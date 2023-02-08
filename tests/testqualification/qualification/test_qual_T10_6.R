test_that("Query rate assessment can return a correctly assessed data frame for the poisson test grouped by the country variable when given correct input data from clindata and the results should be flagged correctly.", {
  # gsm analysis
  dfInput <- gsm::QueryRate_Map_Raw()

  test10_6 <- QueryRate_Assess(
    dfInput = dfInput,
    strMethod = "Poisson",
    strGroup = "Country"
  )

  # double programming
  t10_6_input <- dfInput

  t10_6_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "DataPoint",
      GroupID = "CountryID"
    )

  t10_6_analyzed <- t10_6_transformed %>%
    qualification_analyze_poisson()

  class(t10_6_analyzed) <- c("tbl_df", "tbl", "data.frame")


  t10_6_flagged <- t10_6_analyzed %>%
    qualification_flag_poisson()

  t10_6_summary <- t10_6_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t10_6 <- list(
    "dfTransformed" = t10_6_transformed,
    "dfAnalyzed" = t10_6_analyzed,
    "dfFlagged" = t10_6_flagged,
    "dfSummary" = t10_6_summary
  )

  # compare results
  expect_equal(test10_6$lData[names(test10_6$lData) != "dfBounds"], t10_6)
})
