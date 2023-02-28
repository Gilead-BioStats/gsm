test_that("Given an appropriate subset of Data Change Rate data, the assessment function correctly performs a Data Change Rate Assessment grouped by the Site variable using the Fisher method and correctly assigns Flag variable values when given a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::DataChg_Map_Raw(dfs = list(
    dfDATACHG = clindata::edc_data_change_rate %>% filter(foldername == "Week 120"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test7_1 <- DataChg_Assess(
    dfInput = dfInput,
    strMethod = "Fisher",
    strGroup = "Site",
    vThreshold = c(0.02, 0.06)
  )

  # double programming
  t7_1_input <- dfInput

  t7_1_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total"
    )

  t7_1_analyzed <- t7_1_transformed %>%
    qualification_analyze_fisher()

  class(t7_1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t7_1_flagged <- t7_1_analyzed %>%
    qualification_flag_fisher(threshold = c(0.02, 0.06))

  t7_1_summary <- t7_1_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t7_1 <- list(
    "dfTransformed" = t7_1_transformed,
    "dfAnalyzed" = t7_1_analyzed,
    "dfFlagged" = t7_1_flagged,
    "dfSummary" = t7_1_summary
  )

  # compare results
  expect_equal(test7_1$lData, t7_1)
})
