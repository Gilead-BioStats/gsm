test_that("Given an appropriate subset of Query Age data, the assessment function correctly performs a Query Age Assessment grouped by the Study variable using the Normal Approximation method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::QueryAge_Map_Raw(dfs = list(
    dfQUERY = clindata::edc_queries %>% filter(foldername == "Week 120"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test9_8 <- QueryAge_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "Study"
  )

  # double programming
  t9_8_input <- dfInput

  t9_8_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total",
      GroupID = "StudyID"
    )

  t9_8_analyzed <- t9_8_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t9_8_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t9_8_flagged <- t9_8_analyzed %>%
    qualification_flag_normalapprox()

  t9_8_summary <- t9_8_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t9_8 <- list(
    "dfTransformed" = t9_8_transformed,
    "dfAnalyzed" = t9_8_analyzed,
    "dfFlagged" = t9_8_flagged,
    "dfSummary" = t9_8_summary
  )

  # compare results
  expect_equal(test9_8$lData[names(test9_8$lData) != "dfBounds"], t9_8)
})
