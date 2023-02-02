test_that("PD assessment can return a correctly assessed data frame for the normal approximation test grouped by the site variable when given subset input data from clindata and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Binary(dfs = list(
    dfPD = clindata::rawplus_protdev %>% filter(importnt == "Y"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test27_7 <- PD_Assess_Binary(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    vThreshold = c(-2, -1, 1, 2)
  )

  # Double Programming
  t27_7_input <- dfInput

  t27_7_transformed <- dfInput %>%
    qualification_transform_counts(exposureCol = "Total")

  t27_7_analyzed <- t27_7_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t27_7_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t27_7_flagged <- t27_7_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))

  t27_7_summary <- t27_7_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t27_7 <- list(
    "dfTransformed" = t27_7_transformed,
    "dfAnalyzed" = t27_7_analyzed,
    "dfFlagged" = t27_7_flagged,
    "dfSummary" = t27_7_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test27_7$lData[names(test27_7$lData) != "dfBounds"], t27_7)
})
