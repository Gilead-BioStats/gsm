test_that("PD assessment can return a correctly assessed data frame for the poisson test grouped by a custom variable when given subset input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Binary(dfs = list(
    dfPD = clindata::rawplus_protdev %>% dplyr::filter(importnt == "Y"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test23_2 <- PD_Assess_Binary(
    dfInput = dfInput,
    strMethod = "Poisson",
    strGroup = "CustomGroup"
  )

  # Double Programming
  t23_2_input <- dfInput

  t23_2_transformed <- dfInput %>%
    qualification_transform_counts(
      GroupID = "CustomGroupID",
      exposureCol = "Total"
    )

  t23_2_analyzed <- t23_2_transformed %>%
    qualification_analyze_poisson()

  class(t23_2_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t23_2_flagged <- t23_2_analyzed %>%
    qualification_flag_poisson()

  t23_2_summary <- t23_2_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t23_2 <- list(
    "dfTransformed" = t23_2_transformed,
    "dfAnalyzed" = t23_2_analyzed,
    "dfFlagged" = t23_2_flagged,
    "dfSummary" = t23_2_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test23_2$lData[names(test23_2$lData) != "dfBounds"], t23_2)
})
