test_that("Given an appropriate subset of Adverse Event data, the assessment function correctly performs an Adverse Event Assessment grouped by the Study variable using the Poisson method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Raw(dfs = list(
    dfAE = clindata::rawplus_ae %>% filter(aeser_std_nsv == "Y"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test1_2 <- AE_Assess(
    dfInput = dfInput,
    strMethod = "Poisson",
    strGroup = "Study"
  )

  # Double Programming
  t1_2_input <- dfInput

  t1_2_transformed <- dfInput %>%
    qualification_transform_counts(
      GroupID = "StudyID"
    )

  t1_2_analyzed <- t1_2_transformed %>%
    qualification_analyze_poisson()

  class(t1_2_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t1_2_flagged <- t1_2_analyzed %>%
    qualification_flag_poisson()

  t1_2_summary <- t1_2_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t1_2 <- list(
    "dfTransformed" = t1_2_transformed,
    "dfAnalyzed" = t1_2_analyzed,
    "dfFlagged" = t1_2_flagged,
    "dfSummary" = t1_2_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test1_2$lData[names(test1_2$lData) != "dfBounds"], t1_2)
})
