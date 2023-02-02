test_that("PD assessment can return a correctly assessed data frame for the poisson test grouped by the site variable when given subset input data from clindata and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Binary(dfs = list(
    dfPD = clindata::rawplus_protdev %>% filter(importnt == "Y"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test27_1 <- PD_Assess_Binary(
    dfInput = dfInput,
    strMethod = "Poisson",
    vThreshold = c(-3, -1, 1, 3)
  )

  # Double Programming
  t27_1_input <- dfInput

  t27_1_transformed <- dfInput %>%
    qualification_transform_counts(exposureCol = "Total")

  t27_1_analyzed <- t27_1_transformed %>%
    qualification_analyze_poisson()

  class(t27_1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t27_1_flagged <- t27_1_analyzed %>%
    qualification_flag_poisson(threshold = c(-3, -1, 1, 3))

  t27_1_summary <- t27_1_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t27_1 <- list(
    "dfTransformed" = t27_1_transformed,
    "dfAnalyzed" = t27_1_analyzed,
    "dfFlagged" = t27_1_flagged,
    "dfSummary" = t27_1_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test27_1$lData[names(test27_1$lData) != "dfBounds"], t27_1)
})
