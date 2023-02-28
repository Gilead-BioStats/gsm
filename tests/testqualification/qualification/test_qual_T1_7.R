test_that("Given an appropriate subset of Adverse Event data, the assessment function correctly performs an Adverse Event Assessment grouped by the Site variable using the Normal Approximation method and correctly assigns Flag variable values.", {

  dfInput <- gsm::AE_Map_Raw(dfs = list(
    dfAE = clindata::rawplus_ae %>% filter(aeser_std_nsv == "Y"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test1_7 <- AE_Assess(dfInput,
    strMethod = "NormalApprox",
    vThreshold = c(-3, -2, 2, 3)
  )


  # Double Programming
  t7_input <- dfInput

  t7_transformed <- dfInput %>%
    qualification_transform_counts()

  t7_analyzed <- t7_transformed %>%
    qualification_analyze_normalapprox(strType = "rate")

  class(t7_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t7_flagged <- t7_analyzed %>%
    qualification_flag_normalapprox()

  t7_summary <- t7_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t1_7 <- list(
    "dfTransformed" = t7_transformed,
    "dfAnalyzed" = t7_analyzed,
    "dfFlagged" = t7_flagged %>% arrange(match(Flag, c(2, -2, 1, -1, 0))),
    "dfSummary" = t7_summary
  )

  expect_equal(test1_7$lData[names(test1_7$lData) != "dfBounds"], t1_7)
})
