test_that("Given appropriate Data Entry Lag data, the assessment function correctly performs a Data Entry Lag Assessment grouped by the Country variable using the Normal Approximation method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::DataEntry_Map_Raw()

  test8_9 <- DataEntry_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "Country"
  )

  # double programming
  t8_9_input <- dfInput

  t8_9_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total",
      GroupID = "CountryID"
    )

  t8_9_analyzed <- t8_9_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t8_9_analyzed) <- c("tbl_df", "tbl", "data.frame")


  t8_9_flagged <- t8_9_analyzed %>%
    qualification_flag_normalapprox()

  t8_9_summary <- t8_9_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t8_9 <- list(
    "dfTransformed" = t8_9_transformed,
    "dfAnalyzed" = t8_9_analyzed,
    "dfFlagged" = t8_9_flagged,
    "dfSummary" = t8_9_summary
  )

  # compare results
  expect_equal(test8_9$lData[names(test8_9$lData) != "dfBounds"], t8_9)
})
