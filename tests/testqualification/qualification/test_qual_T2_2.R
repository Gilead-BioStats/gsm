test_that("PD assessment can return a correctly assessed data frame for the poisson test grouped by a custom variable when given subset input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw(dfs = list(
    dfPD = clindata::rawplus_protdev %>% filter(importnt == "Y"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test2_2 <- PD_Assess(
    dfInput = dfInput,
    strMethod = "poisson",
    strGroup = "CustomGroup"
  )

  # Double Programming
  t2_2_input <- dfInput

  t2_2_transformed <- dfInput %>%
    qualification_transform_counts(
      GroupID = "CustomGroupID"
    )

  t2_2_analyzed <- t2_2_transformed %>%
    qualification_analyze_poisson()

  class(t2_2_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t2_2_flagged <- t2_2_analyzed %>%
    qualification_flag_poisson()

  t2_2_summary <- t2_2_flagged %>%
    select(GroupID, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t2_2 <- list(
    "dfTransformed" = t2_2_transformed,
    "dfAnalyzed" = t2_2_analyzed,
    "dfFlagged" = t2_2_flagged,
    "dfSummary" = t2_2_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test2_2$lData[names(test2_2$lData) != "dfBounds"], t2_2)
})
