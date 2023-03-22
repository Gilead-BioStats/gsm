test_that("Given an appropriate subset of Data Change Rate data, the assessment function correctly performs a Data Change Rate Assessment grouped by the Site variable using the Identity method and correctly assigns Flag variable values when given a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::DataChg_Map_Raw(dfs = list(
    dfDATACHG = clindata::edc_data_points %>% filter(visit == "Week 120"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test7_4 <- DataChg_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "Site",
    vThreshold = c(0.00006, 0.01)
  )

  # double programming
  t7_4_input <- dfInput

  t7_4_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total"
    )

  t7_4_analyzed <- t7_4_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t7_4_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t7_4_flagged <- t7_4_analyzed %>%
    qualification_flag_identity(threshold = c(0.00006, 0.01))

  t7_4_summary <- t7_4_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t7_4 <- list(
    "dfTransformed" = t7_4_transformed,
    "dfAnalyzed" = t7_4_analyzed,
    "dfFlagged" = t7_4_flagged,
    "dfSummary" = t7_4_summary
  )

  # compare results
  expect_equal(test7_4$lData, t7_4)
})
