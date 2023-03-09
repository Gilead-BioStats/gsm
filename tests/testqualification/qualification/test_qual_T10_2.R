test_that("Given an appropriate subset of Query Rate data, the assessment function correctly performs a Query Rate Assessment grouped by the Study variable using the Poisson method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::QueryRate_Map_Raw(dfs = list(
    dfQUERY = clindata::edc_queries %>% filter(foldername == "Week 120"),
    dfSUBJ = clindata::rawplus_dm,
    dfDATACHG = clindata::edc_data_change_rate
  ))

  test10_2 <- QueryRate_Assess(
    dfInput = dfInput,
    strMethod = "Poisson",
    strGroup = "Study"
  )

  # double programming
  t10_2_input <- dfInput

  t10_2_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "DataPoint",
      GroupID = "StudyID"
    )

  t10_2_analyzed <- t10_2_transformed %>%
    qualification_analyze_poisson()

  class(t10_2_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t10_2_flagged <- t10_2_analyzed %>%
    qualification_flag_poisson()

  t10_2_summary <- t10_2_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t10_2 <- list(
    "dfTransformed" = t10_2_transformed,
    "dfAnalyzed" = t10_2_analyzed,
    "dfFlagged" = t10_2_flagged,
    "dfSummary" = t10_2_summary
  )

  # compare results
  expect_equal(test10_2$lData[names(test10_2$lData) != "dfBounds"], t10_2)
})
