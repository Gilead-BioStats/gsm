test_that("Given an appropriate subset of Query Rate data, the assessment function correctly performs a Query Rate Assessment grouped by the Site variable using the Identity method and correctly assigns Flag variable values when given a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::QueryRate_Map_Raw(dfs = list(
    dfQUERY = clindata::edc_queries %>% filter(visit == "Week 120"),
    dfSUBJ = clindata::rawplus_dm,
    dfDATACHG = clindata::edc_data_points
  ))

  test10_4 <- QueryRate_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "Site",
    vThreshold = c(0.005, 0.05)
  )

  # double programming
  t10_4_input <- dfInput

  t10_4_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "DataPoint"
    )

  t10_4_analyzed <- t10_4_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t10_4_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t10_4_flagged <- t10_4_analyzed %>%
    qualification_flag_identity(threshold = c(0.005, 0.05))

  t10_4_summary <- t10_4_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t10_4 <- list(
    "dfTransformed" = t10_4_transformed,
    "dfAnalyzed" = t10_4_analyzed,
    "dfFlagged" = t10_4_flagged,
    "dfSummary" = t10_4_summary
  )

  # compare results
  expect_equal(test10_4$lData, t10_4)
})
