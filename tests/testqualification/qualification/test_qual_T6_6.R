test_that("Given an appropriate subset of Labs data, the assessment function correctly performs a Labs Assessment grouped by the Site variable using the Normal Approximation method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::LB_Map_Raw(dfs = list(
    dfSUBJ = clindata::rawplus_dm  %>% filter(!siteid %in% c("5", "29", "58")),
    dfLB = clindata::rawplus_lb))

  test6_6 <- LB_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox"
  )

  # Double Programming
  t6_6_input <- dfInput

  t6_6_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total"
    )

  t6_6_analyzed <- t6_6_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t6_6_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_6_flagged <- t6_6_analyzed %>%
    qualification_flag_normalapprox()

  t6_6_summary <- t6_6_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t6_6 <- list(
    "dfTransformed" = t6_6_transformed,
    "dfAnalyzed" = t6_6_analyzed,
    "dfFlagged" = t6_6_flagged,
    "dfSummary" = t6_6_summary
  )

  # compare results
  expect_equal(test6_6$lData[!names(test6_6$lData) == "dfBounds"], t6_6)
})
