test_that("Given an appropriate subset of Data Entry Lag data, the assessment function correctly performs a Data Entry Lag Assessment grouped by the Study variable using the Normal Approximation method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::DataEntry_Map_Raw(dfs = list(
    dfDATAENT = clindata::edc_data_entry_lag %>% filter(foldername == "Week 120"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test8_8 <- DataEntry_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "Study"
  )

  # double programming
  t8_8_input <- dfInput

  t8_8_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total",
      GroupID = "StudyID"
    )

  t8_8_analyzed <- t8_8_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t8_8_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t8_8_flagged <- t8_8_analyzed %>%
    qualification_flag_normalapprox()

  t8_8_summary <- t8_8_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t8_8 <- list(
    "dfTransformed" = t8_8_transformed,
    "dfAnalyzed" = t8_8_analyzed,
    "dfFlagged" = t8_8_flagged,
    "dfSummary" = t8_8_summary
  )

  # compare results
  expect_equal(test8_8$lData[names(test8_8$lData) != "dfBounds"], t8_8)
})
