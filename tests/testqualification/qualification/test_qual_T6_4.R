test_that("Given an appropriate subset of Labs data, the assessment function correctly performs a Labs Assessment grouped by the Site variable using the Identity method and correctly assigns Flag variable values when given a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::LB_Map_Raw(dfs = list(
    dfSUBJ = clindata::rawplus_dm %>% filter(!siteid %in% c("5", "29", "58")),
    dfLB = clindata::rawplus_lb
  ))

  test6_4 <- LB_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    vThreshold = c(2.31, 6.58)
  )

  # Double Programming
  t6_4_input <- dfInput

  t6_4_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total"
    )

  t6_4_analyzed <- t6_4_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t6_4_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_4_flagged <- t6_4_analyzed %>%
    qualification_flag_identity(threshold = c(2.31, 6.58))

  t6_4_summary <- t6_4_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t6_4 <- list(
    "dfTransformed" = t6_4_transformed,
    "dfAnalyzed" = t6_4_analyzed,
    "dfFlagged" = t6_4_flagged,
    "dfSummary" = t6_4_summary
  )

  # compare results
  expect_equal(test6_4$lData, t6_4)
})
