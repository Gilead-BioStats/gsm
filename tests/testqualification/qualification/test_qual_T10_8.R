test_that("Given an appropriate subset of Query Rate data, the assessment function correctly performs a Query Rate Assessment grouped by the Study variable using the Normal Approximation method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::QueryRate_Map_Raw(dfs = list(
    dfQUERY = clindata::edc_queries %>% filter(visit == "Week 120"),
    dfSUBJ = clindata::rawplus_dm,
    dfDATACHG = clindata::edc_data_points
  ))

  test10_8 <- QueryRate_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "Study"
  )

  # double programming
  t10_8_input <- dfInput

  t10_8_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "DataPoint",
      GroupID = "StudyID"
    )

  t10_8_analyzed <- t10_8_transformed %>%
    qualification_analyze_normalapprox(strType = "rate")

  class(t10_8_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t10_8_flagged <- t10_8_analyzed %>%
    qualification_flag_normalapprox()

  t10_8_summary <- t10_8_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t10_8 <- list(
    "dfTransformed" = t10_8_transformed,
    "dfAnalyzed" = t10_8_analyzed,
    "dfFlagged" = t10_8_flagged,
    "dfSummary" = t10_8_summary
  )

  # compare results
  expect_equal(test10_8$lData[!names(test10_8$lData) %in% c("dfBounds", "dfConfig")], t10_8)
})
