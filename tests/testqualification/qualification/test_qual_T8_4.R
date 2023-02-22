test_that("Data entry assessment can return a correctly assessed data frame for the identity test grouped by the site variable when given subset input data from clindata and the results should be flagged correctly using a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::DataEntry_Map_Raw(dfs = list(
    dfDATAENT = clindata::edc_data_entry_lag %>% filter(foldername == "Week 120"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test8_4 <- DataEntry_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "Site",
    vThreshold = c(0.00006, 0.01)
  )

  # double programming
  t8_4_input <- dfInput

  t8_4_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total"
    )

  t8_4_analyzed <- t8_4_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t8_4_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t8_4_flagged <- t8_4_analyzed %>%
    qualification_flag_identity(threshold = c(0.00006, 0.01))

  t8_4_summary <- t8_4_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t8_4 <- list(
    "dfTransformed" = t8_4_transformed,
    "dfAnalyzed" = t8_4_analyzed,
    "dfFlagged" = t8_4_flagged,
    "dfSummary" = t8_4_summary
  )

  # compare results
  expect_equal(test8_4$lData, t8_4)
})
