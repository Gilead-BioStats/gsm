test_that("Given an appropriate subset of Adverse Event data, the assessment function correctly performs an Adverse Event Assessment grouped by the Study variable using the Normal Approximation method  and correctly assigns Flag variable values.", {
  dfInput <- gsm::AE_Map_Raw(dfs = list(
    dfAE = clindata::rawplus_ae %>% filter(aeser_std_nsv == "Y"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test1_8 <- AE_Assess(dfInput,
    strMethod = "NormalApprox",
    strGroup = "Study"
  )


  # Double Programming
  t8_input <- dfInput

  t8_transformed <- dfInput %>%
    qualification_transform_counts(
      GroupID = "StudyID"
    )

  t8_analyzed <- t8_transformed %>%
    qualification_analyze_normalapprox(strType = "rate")

  class(t8_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t8_flagged <- t8_analyzed %>%
    qualification_flag_normalapprox()

  t8_summary <- t8_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t1_8 <- list(
    "dfTransformed" = t8_transformed,
    "dfAnalyzed" = t8_analyzed,
    "dfFlagged" = t8_flagged %>% arrange(match(Flag, c(2, -2, 1, -1, 0))),
    "dfSummary" = t8_summary
  )

  # remove metadata that is not part of qualification
  test1_8$lData$dfConfig <- NULL

  expect_equal(test1_8$lData[names(test1_8$lData) != "dfBounds"], t1_8)
})
