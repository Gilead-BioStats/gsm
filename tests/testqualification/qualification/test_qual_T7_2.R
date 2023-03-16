test_that("Given an appropriate subset of Data Change Rate data, the assessment function correctly performs a Data Change Rate Assessment grouped by the Country variable using the Fisher method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::DataChg_Map_Raw(dfs = list(
    dfDATACHG = clindata::edc_data_points %>% filter(visit == "Week 120"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test7_2 <- DataChg_Assess(
    dfInput = dfInput,
    strMethod = "Fisher",
    strGroup = "Country"
  )

  # double programming
  t7_2_input <- dfInput

  t7_2_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total",
      GroupID = "CountryID"
    )

  t7_2_analyzed <- t7_2_transformed %>%
    qualification_analyze_fisher()

  class(t7_2_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t7_2_flagged <- t7_2_analyzed %>%
    qualification_flag_fisher()

  t7_2_summary <- t7_2_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t7_2 <- list(
    "dfTransformed" = t7_2_transformed,
    "dfAnalyzed" = t7_2_analyzed,
    "dfFlagged" = t7_2_flagged,
    "dfSummary" = t7_2_summary
  )

  # compare results
  expect_equal(test7_2$lData, t7_2)
})
