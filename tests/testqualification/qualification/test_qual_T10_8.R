test_that("Query rate assessment can return a correctly assessed data frame for the normal approximation test grouped by a custom variable when given subset input data from clindata and the results should be flagged correctly.", {
  # gsm analysis
  dfInput <- gsm::QueryRate_Map_Raw(dfs = list(
    dfQUERY = clindata::edc_queries %>% filter(foldername == "Week 120"),
    dfSUBJ = clindata::rawplus_dm,
    dfDATACHG = clindata::edc_data_change_rate
  ))

  test10_8 <- QueryRate_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "CustomGroup"
  )

  # double programming
  t10_8_input <- dfInput

  t10_8_transformed <- dfInput %>%
    qualification_transform_counts(countCol = "Count",
                                   exposureCol = "DataPoint",
                                   GroupID = "CustomGroupID")

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
  expect_equal(test10_8$lData[names(test10_8$lData) != "dfBounds"], t10_8)
})
