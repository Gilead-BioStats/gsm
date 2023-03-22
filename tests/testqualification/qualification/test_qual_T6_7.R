test_that("Given an appropriate subset of Labs data, the assessment function correctly performs a Labs Assessment grouped by the Site variable using the Normal Approximation method and correctly assigns Flag variable values when given a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::LB_Map_Raw(dfs = list(
    dfSUBJ = clindata::rawplus_dm  %>% filter(!siteid %in% c("5", "29", "58")),
    dfLB = clindata::rawplus_lb))

  test6_7 <- LB_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    vThreshold = c(-2, -1, 1, 2)
  )

  # Double Programming
  t6_7_input <- dfInput

  t6_7_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total"
    )

  t6_7_analyzed <- t6_7_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t6_7_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_7_flagged <- t6_7_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))

  t6_7_summary <- t6_7_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t6_7 <- list(
    "dfTransformed" = t6_7_transformed,
    "dfAnalyzed" = t6_7_analyzed,
    "dfFlagged" = t6_7_flagged,
    "dfSummary" = t6_7_summary
  )

  # compare results
  expect_equal(test6_7$lData[!names(test6_7$lData) == "dfBounds"], t6_7)
})
