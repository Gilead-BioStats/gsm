test_that("Query age assessment can return a correctly assessed data frame for the fisher test grouped by the site variable when given subset input data from clindata and the results should be flagged correctly using a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::QueryAge_Map_Raw(dfs = list(
    dfQUERY = clindata::edc_queries %>% filter(foldername == "Week 120"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test9_4 <- QueryAge_Assess(
    dfInput = dfInput,
    strMethod = "Fisher",
    strGroup = "Site",
    vThreshold = c(0.02, 0.06)
  )

  # double programming
  t9_4_input <- dfInput

  t9_4_transformed <- dfInput %>%
    qualification_transform_counts(countCol = "Count",
                                   exposureCol = "Total")

  t9_4_analyzed <- t9_4_transformed %>%
    qualification_analyze_fisher()

  class(t9_4_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t9_4_flagged <- t9_4_analyzed %>%
    qualification_flag_fisher(threshold = c(0.02, 0.06))

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
