test_that("Given an appropriate subset of Query Rate data, the assessment function correctly performs a Query Rate Assessment grouped by the Site variable using the Normal Approximation method and correctly assigns Flag variable values when given a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::QueryRate_Map_Raw(dfs = list(
    dfQUERY = clindata::edc_queries %>% filter(visit == "Week 120"),
    dfSUBJ = clindata::rawplus_dm,
    dfDATACHG = clindata::edc_data_points
  ))

  test10_7 <- QueryRate_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "Site",
    vThreshold = c(-2, -1, 1, 2)
  )

  # double programming
  t10_7_input <- dfInput

  t10_7_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "DataPoint"
    )

  t10_7_analyzed <- t10_7_transformed %>%
    qualification_analyze_normalapprox(strType = "rate")

  class(t10_7_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t10_7_flagged <- t10_7_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))

  t10_7_summary <- t10_7_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t10_7 <- list(
    "dfTransformed" = t10_7_transformed,
    "dfAnalyzed" = t10_7_analyzed,
    "dfFlagged" = t10_7_flagged,
    "dfSummary" = t10_7_summary
  )

  # compare results
  expect_equal(test10_7$lData[!names(test10_7$lData) %in% c("dfBounds", "dfConfig")], t10_7)
})
