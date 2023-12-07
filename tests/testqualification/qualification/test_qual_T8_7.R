test_that("Given an appropriate subset of Data Entry Lag data, the assessment function correctly performs a Data Entry Lag Assessment grouped by the Site variable using the Normal Approximation method and correctly assigns Flag variable values when given a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::DataEntry_Map_Raw(dfs = list(
    dfDATAENT = clindata::edc_data_pages %>% filter(visit == "Week 120"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test8_7 <- DataEntry_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "Site",
    vThreshold = c(-2, -1, 1, 2)
  )

  # double programming
  t8_7_input <- dfInput

  t8_7_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total"
    )

  t8_7_analyzed <- t8_7_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t8_7_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t8_7_flagged <- t8_7_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))

  t8_7_summary <- t8_7_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t8_7 <- list(
    "dfTransformed" = t8_7_transformed,
    "dfAnalyzed" = t8_7_analyzed,
    "dfFlagged" = t8_7_flagged,
    "dfSummary" = t8_7_summary
  )

  # compare results
  expect_equal(test8_7$lData[!names(test8_7$lData) %in% c("dfBounds", "dfConfig")], t8_7)
})
