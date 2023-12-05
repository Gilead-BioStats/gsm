test_that("Given an appropriate subset of Protocol Deviation data, the assessment function correctly performs a Protocol Deviation Assessment grouped by the Site variable using the Poisson method and correctly assigns Flag variable values when given a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Rate(dfs = list(
    dfPD = clindata::ctms_protdev %>% filter(deemedimportant == "Yes"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test2_1 <- PD_Assess_Rate(
    dfInput = dfInput,
    strMethod = "Poisson",
    vThreshold = c(-3, -1, 1, 3)
  )

  # Double Programming
  t2_1_input <- dfInput

  t2_1_transformed <- dfInput %>%
    qualification_transform_counts()

  t2_1_analyzed <- t2_1_transformed %>%
    qualification_analyze_poisson()

  class(t2_1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t2_1_flagged <- t2_1_analyzed %>%
    qualification_flag_poisson(threshold = c(-3, -1, 1, 3))

  t2_1_summary <- t2_1_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t2_1 <- list(
    "dfTransformed" = t2_1_transformed,
    "dfAnalyzed" = t2_1_analyzed,
    "dfFlagged" = t2_1_flagged,
    "dfSummary" = t2_1_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test2_1$lData[!names(test2_1$lData) %in% c("dfBounds", "dfConfig")], t2_1)
})
