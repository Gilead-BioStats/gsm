test_that("Given an appropriate subset of Query Age data, the assessment function correctly performs a Query Age Assessment grouped by a custom variable using the Fisher method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::QueryAge_Map_Raw(dfs = list(
    dfQUERY = clindata::edc_queries %>% filter(foldername == "Week 120"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test9_2 <- QueryAge_Assess(
    dfInput = dfInput,
    strMethod = "Fisher",
    strGroup = "CustomGroup"
  )

  # double programming
  t9_2_input <- dfInput

  t9_2_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total",
      GroupID = "CustomGroupID"
    )

  t9_2_analyzed <- t9_2_transformed %>%
    qualification_analyze_fisher()

  class(t9_2_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t9_2_flagged <- t9_2_analyzed %>%
    qualification_flag_fisher()

  t9_2_summary <- t9_2_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t9_2 <- list(
    "dfTransformed" = t9_2_transformed,
    "dfAnalyzed" = t9_2_analyzed,
    "dfFlagged" = t9_2_flagged,
    "dfSummary" = t9_2_summary
  )

  # compare results
  expect_equal(test9_2$lData, t9_2)
})
