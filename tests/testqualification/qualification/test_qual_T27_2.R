test_that("PD assessment can return a correctly assessed data frame for the poisson test grouped by a custom variable when given subset input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Binary(dfs = list(
    dfPD = clindata::rawplus_protdev %>% filter(importnt == "Y"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test27_2 <- PD_Assess_Binary(
    dfInput = dfInput,
    strMethod = "Poisson",
    strGroup = "CustomGroup"
  )

  # Double Programming
  t27_2_input <- dfInput

  t27_2_transformed <- dfInput %>%
    qualification_transform_counts(
      GroupID = "CustomGroupID",
      exposureCol = "Total"
    )

  t27_2_analyzed <- t27_2_transformed %>%
    qualification_analyze_poisson()

  class(t27_2_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t27_2_flagged <- t27_2_analyzed %>%
    qualification_flag_poisson()

  t27_2_summary <- t27_2_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t27_2 <- list(
    "dfTransformed" = t27_2_transformed,
    "dfAnalyzed" = t27_2_analyzed,
    "dfFlagged" = t27_2_flagged,
    "dfSummary" = t27_2_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test27_2$lData[names(test27_2$lData) != "dfBounds"], t27_2)
})
