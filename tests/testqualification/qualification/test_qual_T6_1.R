test_that("Given an appropriate subset of Labs data, the assessment function correctly performs a Labs Assessment grouped by the Site variable using the Fisher method and correctly assigns Flag variable values when given a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::LB_Map_Raw(dfs = list(
    dfSUBJ = clindata::rawplus_dm  %>% filter(!siteid %in% c("5", "29", "58")),
    dfLB = clindata::rawplus_lb))

  test6_1 <- LB_Assess(
    dfInput = dfInput,
    strMethod = "Fisher",
    vThreshold = c(.025, .05)
  )

  # Double Programming
  t6_1_input <- dfInput

  t6_1_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total"
    )

  t6_1_analyzed <- t6_1_transformed %>%
    qualification_analyze_fisher()

  class(t6_1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_1_flagged <- t6_1_analyzed %>%
    qualification_flag_fisher(threshold = c(.025, .05))

  t6_1_summary <- t6_1_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t6_1 <- list(
    "dfTransformed" = t6_1_transformed,
    "dfAnalyzed" = t6_1_analyzed,
    "dfFlagged" = t6_1_flagged,
    "dfSummary" = t6_1_summary
  )

  # compare results
  expect_equal(test6_1$lData, t6_1)
})
