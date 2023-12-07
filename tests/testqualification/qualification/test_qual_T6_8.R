test_that("Given an appropriate subset of Labs data, the assessment function correctly performs a Labs Assessment grouped by the Study variable using the Normal Approximation method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::LB_Map_Raw(dfs = list(
    dfSUBJ = clindata::rawplus_dm %>% filter(!siteid %in% c("5", "29", "58")),
    dfLB = clindata::rawplus_lb
  ))

  test6_8 <- LB_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "Study"
  )

  # Double Programming
  t6_8_input <- dfInput

  t6_8_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
      GroupID = "StudyID"
    )

  t6_8_analyzed <- t6_8_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t6_8_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_8_flagged <- t6_8_analyzed %>%
    qualification_flag_normalapprox()

  t6_8_summary <- t6_8_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t6_8 <- list(
    "dfTransformed" = t6_8_transformed,
    "dfAnalyzed" = t6_8_analyzed,
    "dfFlagged" = t6_8_flagged,
    "dfSummary" = t6_8_summary
  )

  # compare results
  expect_equal(test6_8$lData[!names(test6_8$lData) %in% c("dfBounds", "dfConfig")], t6_8)
})
