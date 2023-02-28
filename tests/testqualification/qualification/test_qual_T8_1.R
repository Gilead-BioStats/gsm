test_that("Given an appropriate subset of Data Entry Lag data, the assessment function correctly performs a Data Entry Lag Assessment grouped by the Site variable using the Fisher method and correctly assigns Flag variable values when given a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::DataEntry_Map_Raw(dfs = list(
    dfDATAENT = clindata::edc_data_entry_lag %>% filter(foldername == "Week 120"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test8_1 <- DataEntry_Assess(
    dfInput = dfInput,
    strMethod = "Fisher",
    strGroup = "Site",
    vThreshold = c(0.02, 0.06)
  )

  # double programming
  t8_1_input <- dfInput

  t8_1_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total"
    )

  t8_1_analyzed <- t8_1_transformed %>%
    qualification_analyze_fisher()

  class(t8_1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t8_1_flagged <- t8_1_analyzed %>%
    qualification_flag_fisher(threshold = c(0.02, 0.06))

  t8_1_summary <- t8_1_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t8_1 <- list(
    "dfTransformed" = t8_1_transformed,
    "dfAnalyzed" = t8_1_analyzed,
    "dfFlagged" = t8_1_flagged,
    "dfSummary" = t8_1_summary
  )

  # compare results
  expect_equal(test8_1$lData, t8_1)
})
