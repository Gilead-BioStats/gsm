test_that("PD assessment can return a correctly assessed data frame for the normal approximation test grouped by the site variable when given subset input data from clindata and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Binary(dfs = list(
    dfPD = clindata::rawplus_protdev %>% dplyr::filter(importnt == "Y"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test23_7 <- PD_Assess_Binary(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    vThreshold = c(-2, -1, 1, 2)
  )

  # Double Programming
  t23_7_input <- dfInput

  t23_7_transformed <- dfInput %>%
    qualification_transform_counts(exposureCol = "Total")

  t23_7_analyzed <- t23_7_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t23_7_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t23_7_flagged <- t23_7_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))

  t23_7_summary <- t23_7_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t23_7 <- list(
    "dfTransformed" = t23_7_transformed,
    "dfAnalyzed" = t23_7_analyzed,
    "dfFlagged" = t23_7_flagged,
    "dfSummary" = t23_7_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test23_7$lData[names(test23_7$lData) != "dfBounds"], t23_7)
})
