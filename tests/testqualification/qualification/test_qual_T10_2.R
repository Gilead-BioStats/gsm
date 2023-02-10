test_that("Query rate assessment can return a correctly assessed data frame for the identity test grouped by a custom variable when given subset input data from clindata and the results should be flagged correctly.", {
  # gsm analysis
  dfInput <- gsm::QueryRate_Map_Raw(dfs = list(
    dfQUERY = clindata::edc_queries %>% filter(foldername == "Week 120"),
    dfSUBJ = clindata::rawplus_dm,
    dfDATACHG = clindata::edc_data_change_rate
  ))

  test10_2 <- QueryRate_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "CustomGroup"
  )

  # double programming
  t10_2_input <- dfInput

  t10_2_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "DataPoint",
      GroupID = "CustomGroupID"
    )

  t10_2_analyzed <- t10_2_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t10_2_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t10_2_flagged <- t10_2_analyzed %>%
    qualification_flag_identity(threshold = c(0.00006, 0.01))

  t10_2_summary <- t10_2_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t10_2 <- list(
    "dfTransformed" = t10_2_transformed,
    "dfAnalyzed" = t10_2_analyzed,
    "dfFlagged" = t10_2_flagged,
    "dfSummary" = t10_2_summary
  )

  # compare results
  expect_equal(test10_2$lData, t10_2)
})
