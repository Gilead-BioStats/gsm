test_that("Given an appropriate subset of Protocol Deviation data, the assessment function correctly performs a Protocol Deviation Assessment grouped by the Site variable using the Normal Approximation method and correctly assigns Flag variable values when given a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Rate(dfs = list(
    dfPD = clindata::rawplus_protdev %>% filter(importnt == "Y"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test2_7 <- PD_Assess_Rate(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    vThreshold = c(-2, -1, 1, 2)
  )

  # Double Programming
  t2_7_input <- dfInput

  t2_7_transformed <- dfInput %>%
    qualification_transform_counts()

  t2_7_analyzed <- t2_7_transformed %>%
    qualification_analyze_normalapprox(strType = "rate")

  class(t2_7_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t2_7_flagged <- t2_7_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))

  t2_7_summary <- t2_7_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t2_7 <- list(
    "dfTransformed" = t2_7_transformed,
    "dfAnalyzed" = t2_7_analyzed,
    "dfFlagged" = t2_7_flagged,
    "dfSummary" = t2_7_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test2_7$lData[names(test2_7$lData) != "dfBounds"], t2_7)
})
