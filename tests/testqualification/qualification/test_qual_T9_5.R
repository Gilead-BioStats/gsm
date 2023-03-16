test_that("Given an appropriate subset of Query Age data, the assessment function correctly performs a Query Age Assessment grouped by the Study variable using the Identity method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::QueryAge_Map_Raw(dfs = list(
    dfQUERY = clindata::edc_queries %>% filter(visit == "Week 120"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test9_5 <- QueryAge_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "Study"
  )

  # double programming
  t9_5_input <- dfInput

  t9_5_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total",
      GroupID = "StudyID"
    )

  t9_5_analyzed <- t9_5_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t9_5_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t9_5_flagged <- t9_5_analyzed %>%
    qualification_flag_identity()

  t9_5_summary <- t9_5_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t9_5 <- list(
    "dfTransformed" = t9_5_transformed,
    "dfAnalyzed" = t9_5_analyzed,
    "dfFlagged" = t9_5_flagged,
    "dfSummary" = t9_5_summary
  )

  # compare results
  expect_equal(test9_5$lData, t9_5)
})
