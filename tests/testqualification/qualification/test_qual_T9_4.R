test_that("Given an appropriate subset of Query Age data, the assessment function correctly performs a Query Age Assessment grouped by the Site variable using the Identity method and correctly assigns Flag variable values when given a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::QueryAge_Map_Raw(dfs = list(
    dfQUERY = clindata::edc_queries %>% filter(visit == "Week 120"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test9_4 <- QueryAge_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "Site",
    vThreshold = c(0.00006, 0.01)
  )

  # double programming
  t9_4_input <- dfInput

  t9_4_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total"
    )

  t9_4_analyzed <- t9_4_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t9_4_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t9_4_flagged <- t9_4_analyzed %>%
    qualification_flag_identity(threshold = c(0.00006, 0.01))

  t9_4_summary <- t9_4_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t9_4 <- list(
    "dfTransformed" = t9_4_transformed,
    "dfAnalyzed" = t9_4_analyzed,
    "dfFlagged" = t9_4_flagged,
    "dfSummary" = t9_4_summary
  )

  # compare results
  expect_equal(test9_4$lData, t9_4)
})
