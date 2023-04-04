test_that("Given an appropriate subset of Query Rate data, the assessment function correctly performs a Query Rate Assessment grouped by the Site variable using the Poisson method and correctly assigns Flag variable values when given a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::QueryRate_Map_Raw(dfs = list(
    dfQUERY = clindata::edc_queries %>% filter(visit == "Week 120"),
    dfSUBJ = clindata::rawplus_dm,
    dfDATACHG = clindata::edc_data_points
  ))

  test10_1 <- QueryRate_Assess(
    dfInput = dfInput,
    strMethod = "Poisson",
    strGroup = "Site",
    vThreshold = c(-6, -4, 4, 6)
  )

  # double programming
  t10_1_input <- dfInput

  t10_1_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "DataPoint"
    )

  t10_1_analyzed <- t10_1_transformed %>%
    qualification_analyze_poisson()

  class(t10_1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t10_1_flagged <- t10_1_analyzed %>%
    qualification_flag_poisson(threshold = c(-6, -4, 4, 6))

  t10_1_summary <- t10_1_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t10_1 <- list(
    "dfTransformed" = t10_1_transformed,
    "dfAnalyzed" = t10_1_analyzed,
    "dfFlagged" = t10_1_flagged,
    "dfSummary" = t10_1_summary
  )

  # compare results
  expect_equal(test10_1$lData[names(test10_1$lData) != "dfBounds"], t10_1)
})
