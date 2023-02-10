test_that("Query rate assessment can return a correctly assessed data frame for the identity test grouped by the site variable when given subset input data from clindata and the results should be flagged correctly using a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::QueryRate_Map_Raw(dfs = list(
    dfQUERY = clindata::edc_queries %>% filter(foldername == "Week 120"),
    dfSUBJ = clindata::rawplus_dm,
    dfDATACHG = clindata::edc_data_change_rate
  ))

  test10_1 <- QueryRate_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "Site",
    vThreshold = c(0.005, 0.05)
  )

  # double programming
  t10_1_input <- dfInput

  t10_1_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "DataPoint"
    )

  t10_1_analyzed <- t10_1_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t10_1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t10_1_flagged <- t10_1_analyzed %>%
    qualification_flag_identity(threshold = c(0.005, 0.05))

  t10_1_summary <- t10_1_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t10_1 <- list(
    "dfTransformed" = t10_1_transformed,
    "dfAnalyzed" = t10_1_analyzed,
    "dfFlagged" = t10_1_flagged,
    "dfSummary" = t10_1_summary
  )

  # compare results
  expect_equal(test10_1$lData, t10_1)
})
