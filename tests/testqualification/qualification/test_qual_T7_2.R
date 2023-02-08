test_that("Data change assessment can return a correctly assessed data frame for the identity test grouped by a custom variable when given subset input data from clindata and the results should be flagged correctly.", {
  # gsm analysis
  dfInput <- gsm::DataChg_Map_Raw(dfs = list(
    dfDATACHG = clindata::edc_data_change_rate %>% filter(foldername == "Week 120"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test7_2 <- DataChg_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "CustomGroup"
  )

  # double programming
  t7_2_input <- dfInput

  t7_2_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total",
      GroupID = "CustomGroupID"
    )

  t7_2_analyzed <- t7_2_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t7_2_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t7_2_flagged <- t7_2_analyzed %>%
    qualification_flag_identity()

  t7_2_summary <- t7_2_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t7_2 <- list(
    "dfTransformed" = t7_2_transformed,
    "dfAnalyzed" = t7_2_analyzed,
    "dfFlagged" = t7_2_flagged,
    "dfSummary" = t7_2_summary
  )

  # compare results
  expect_equal(test7_2$lData, t7_2)
})
