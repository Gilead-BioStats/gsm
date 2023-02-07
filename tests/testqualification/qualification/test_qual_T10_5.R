test_that("Query rate assessment can return a correctly assessed data frame for the poisson test grouped by a custom variable when given subset input data from clindata and the results should be flagged correctly.", {
  # gsm analysis
  dfInput <- gsm::QueryRate_Map_Raw(dfs = list(
    dfQUERY = clindata::edc_queries %>% filter(foldername == "Week 120"),
    dfSUBJ = clindata::rawplus_dm,
    dfDATACHG = clindata::edc_data_change_rate
  ))

  test10_5 <- QueryRate_Assess(
    dfInput = dfInput,
    strMethod = "Poisson",
    strGroup = "CustomGroup"
  )

  # double programming
  t10_5_input <- dfInput

  t10_5_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "DataPoint",
      GroupID = "CustomGroupID"
    )

  t10_5_analyzed <- t10_5_transformed %>%
    qualification_analyze_poisson()

  class(t10_5_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t10_5_flagged <- t10_5_analyzed %>%
    qualification_flag_poisson()

  t10_5_summary <- t10_5_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t10_5 <- list(
    "dfTransformed" = t10_5_transformed,
    "dfAnalyzed" = t10_5_analyzed,
    "dfFlagged" = t10_5_flagged,
    "dfSummary" = t10_5_summary
  )

  # compare results
  expect_equal(test10_5$lData[names(test10_5$lData) != "dfBounds"], t10_5)
})
