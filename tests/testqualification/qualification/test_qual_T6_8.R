test_that("Labs assessment can return a correctly assessed data frame grouped by a custom variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- gsm::LB_Map_Raw()

  test6_8 <- LB_Assess(
    dfInput = dfInput,
    vThreshold = c(-2, -1, 1, 2),
    strGroup = "CustomGroup",
    strMethod = "NormalApprox"
  )

  # Double Programming
  t6_8_input <- dfInput

  t6_8_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
      GroupID = "CustomGroupID"
    )

  t6_8_analyzed <- t6_8_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t6_8_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_8_flagged <- t6_8_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))

  t6_8_summary <- t6_8_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t6_8 <- list(
    "dfTransformed" = t6_8_transformed,
    "dfAnalyzed" = t6_8_analyzed,
    "dfFlagged" = t6_8_flagged,
    "dfSummary" = t6_8_summary
  )

  # compare results
  expect_equal(test6_8$lData[!names(test6_8$lData) == "dfBounds"], t6_8)
})
