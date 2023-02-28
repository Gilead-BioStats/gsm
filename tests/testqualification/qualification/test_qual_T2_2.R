test_that("Given an appropriate subset of Protocol Deviation data, the assessment function correctly performs a Protocol Deviation Assessment grouped by the Study variable using the Poisson method and correctly assigns Flag variable values when given a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Rate(dfs = list(
    dfPD = clindata::rawplus_protdev %>% filter(importnt == "Y"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test2_2 <- PD_Assess_Rate(
    dfInput = dfInput,
    strMethod = "Poisson",
    vThreshold = c(-3, -1, 1, 3),
    strGroup = "Study"
  )

  # Double Programming
  t2_2_input <- dfInput

  t2_2_transformed <- dfInput %>%
    qualification_transform_counts(GroupID = "StudyID")

  t2_2_analyzed <- t2_2_transformed %>%
    qualification_analyze_poisson()

  class(t2_2_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t2_2_flagged <- t2_2_analyzed %>%
    qualification_flag_poisson(threshold = c(-3, -1, 1, 3))

  t2_2_summary <- t2_2_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

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
