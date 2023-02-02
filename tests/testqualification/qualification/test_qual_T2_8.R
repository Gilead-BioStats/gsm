test_that("PD assessment can return a correctly assessed data frame for the normal approximation test grouped by a custom variable when given subset input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Rate(dfs = list(
    dfPD = clindata::rawplus_protdev %>% filter(importnt == "Y"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test2_8 <- PD_Assess_Rate(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "CustomGroup",
    vThreshold = c(-2, -1, 1, 2)
  )

  # Double Programming
  t2_8_input <- dfInput

  t2_8_transformed <- dfInput %>%
    qualification_transform_counts(
      GroupID = "CustomGroupID"
    )

  t2_8_analyzed <- t2_8_transformed %>%
    qualification_analyze_normalapprox(strType = "rate")

  class(t2_8_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t2_8_flagged <- t2_8_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))

  t2_8_summary <- t2_8_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t2_8 <- list(
    "dfTransformed" = t2_8_transformed,
    "dfAnalyzed" = t2_8_analyzed,
    "dfFlagged" = t2_8_flagged,
    "dfSummary" = t2_8_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test2_8$lData[names(test2_8$lData) != "dfBounds"], t2_8)
})
