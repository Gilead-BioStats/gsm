test_that("Data change assessment can return a correctly assessed data frame for the identity test grouped by a custom variable when given subset input data from clindata and the results should be flagged correctly.", {
  # gsm analysis
  dfInput <- gsm::DataChg_Map_Raw(dfs = list(
    dfDATACHG = clindata::edc_data_change_rate %>% filter(foldername == "Week 120"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test7_5 <- DataChg_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "CustomGroup"
  )

  # double programming
  t7_5_input <- dfInput

  t7_5_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total",
      GroupID = "CustomGroupID"
    )

  t7_5_analyzed <- t7_5_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t7_5_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t7_5_flagged <- t7_5_analyzed %>%
    qualification_flag_identity()

  t7_5_summary <- t7_5_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t7_5 <- list(
    "dfTransformed" = t7_5_transformed,
    "dfAnalyzed" = t7_5_analyzed,
    "dfFlagged" = t7_5_flagged,
    "dfSummary" = t7_5_summary
  )

  # compare results
  expect_equal(test7_5$lData, t7_5)
})
