test_that("Given an appropriate subset of Data Entry Lag data, the assessment function correctly performs a Data Entry Lag Assessment grouped by a custom variable using the Fisher method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::DataEntry_Map_Raw(dfs = list(
    dfDATAENT = clindata::edc_data_entry_lag %>% filter(foldername == "Week 120"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test8_2 <- DataEntry_Assess(
    dfInput = dfInput,
    strMethod = "Fisher",
    strGroup = "CustomGroup"
  )

  # double programming
  t8_2_input <- dfInput

  t8_2_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total",
      GroupID = "CustomGroupID"
    )

  t8_2_analyzed <- t8_2_transformed %>%
    qualification_analyze_fisher()

  class(t8_2_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t8_2_flagged <- t8_2_analyzed %>%
    qualification_flag_fisher()

  t8_2_summary <- t8_2_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t8_2 <- list(
    "dfTransformed" = t8_2_transformed,
    "dfAnalyzed" = t8_2_analyzed,
    "dfFlagged" = t8_2_flagged,
    "dfSummary" = t8_2_summary
  )

  # compare results
  expect_equal(test8_2$lData, t8_2)
})
