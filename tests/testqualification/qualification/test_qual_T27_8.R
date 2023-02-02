test_that("PD assessment can return a correctly assessed data frame for the normal approximation test grouped by a custom variable when given subset input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Binary(dfs = list(
    dfPD = clindata::rawplus_protdev %>% filter(importnt == "Y"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test27_8 <- PD_Assess_Binary(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "CustomGroup",
    vThreshold = c(-2, -1, 1, 2)
  )

  # Double Programming
  t27_8_input <- dfInput

  t27_8_transformed <- dfInput %>%
    qualification_transform_counts(
      GroupID = "CustomGroupID",
      exposureCol = "Total"
    )

  t27_8_analyzed <- t27_8_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t27_8_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t27_8_flagged <- t27_8_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))

  t27_8_summary <- t27_8_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t27_8 <- list(
    "dfTransformed" = t27_8_transformed,
    "dfAnalyzed" = t27_8_analyzed,
    "dfFlagged" = t27_8_flagged,
    "dfSummary" = t27_8_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test27_8$lData[names(test27_8$lData) != "dfBounds"], t27_8)
})
