test_that("Given appropriate Query Rate data, the assessment function correctly performs a Query Rate Assessment grouped by the Country variable using the Normal Approximation method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::QueryRate_Map_Raw()

  test10_9 <- QueryRate_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "Country"
  )

  # double programming
  t10_9_input <- dfInput

  t10_9_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "DataPoint",
      GroupID = "CountryID"
    )

  t10_9_analyzed <- t10_9_transformed %>%
    qualification_analyze_normalapprox(strType = "rate")

  class(t10_9_analyzed) <- c("tbl_df", "tbl", "data.frame")


  t10_9_flagged <- t10_9_analyzed %>%
    qualification_flag_normalapprox()

  t10_9_summary <- t10_9_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t10_9 <- list(
    "dfTransformed" = t10_9_transformed,
    "dfAnalyzed" = t10_9_analyzed,
    "dfFlagged" = t10_9_flagged,
    "dfSummary" = t10_9_summary
  )

  # compare results
  expect_equal(test10_9$lData[names(test10_9$lData) != "dfBounds"], t10_9)
})
