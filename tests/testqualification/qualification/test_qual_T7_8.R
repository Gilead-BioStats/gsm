test_that("Given an appropriate subset of Data Change Rate data, the assessment function correctly performs a Data Change Rate Assessment grouped by a custom variable using the Normal Approximation method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::DataChg_Map_Raw(dfs = list(
    dfDATACHG = clindata::edc_data_change_rate %>% filter(foldername == "Week 120"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test7_8 <- DataChg_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "CustomGroup"
  )

  # double programming
  t7_8_input <- dfInput

  t7_8_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total",
      GroupID = "CustomGroupID"
    )

  t7_8_analyzed <- t7_8_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t7_8_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t7_8_flagged <- t7_8_analyzed %>%
    qualification_flag_normalapprox()

  t7_8_summary <- t7_8_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t7_8 <- list(
    "dfTransformed" = t7_8_transformed,
    "dfAnalyzed" = t7_8_analyzed,
    "dfFlagged" = t7_8_flagged,
    "dfSummary" = t7_8_summary
  )

  # compare results
  expect_equal(test7_8$lData[names(test7_8$lData) != "dfBounds"], t7_8)
})
