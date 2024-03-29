test_that("Given an appropriate subset of Query Age data, the assessment function correctly performs a Query Age Assessment grouped by the Site variable using the Normal Approximation method and correctly assigns Flag variable values when given a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::QueryAge_Map_Raw(dfs = list(
    dfQUERY = clindata::edc_queries %>% filter(visit == "Week 120"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test9_7 <- QueryAge_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "Site",
    vThreshold = c(-2, -1, 1, 2)
  )

  # double programming
  t9_7_input <- dfInput

  t9_7_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total"
    )

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

  # remove metadata that is not part of qualification
  test9_7$lData$dfConfig <- NULL

  # compare results
  expect_equal(test9_7$lData[names(test9_7$lData) != "dfBounds"], t9_7)
})
