test_that("Given an appropriate subset of Disposition data, the assessment function correctly performs a Disposition Assessment grouped by the Site variable using the Normal Approximation method and correctly assigns Flag variable values when given a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::Disp_Map_Raw(dfs = list(
    dfSUBJ = clindata::rawplus_dm,
    dfSTUDCOMP = clindata::rawplus_studcomp %>% filter(compreas_std_nsv == "ID"),
    dfSDRGCOMP = clindata::rawplus_sdrgcomp %>% filter(datapagename ==
      "Blinded Study Drug Completion")
  ))

  test5_7 <- Disp_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    vThreshold = c(-2, -1, 1, 2)
  )

  # Double Programming
  t5_7_input <- dfInput

  t5_7_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total"
    )

  t5_7_analyzed <- t5_7_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t5_7_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_7_flagged <- t5_7_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))

  t5_7_summary <- t5_7_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t5_7 <- list(
    "dfTransformed" = t5_7_transformed,
    "dfAnalyzed" = t5_7_analyzed,
    "dfFlagged" = t5_7_flagged,
    "dfSummary" = t5_7_summary
  )

  # compare results
  expect_equal(test5_7$lData[!names(test5_7$lData) %in% c("dfBounds", "dfConfig")], t5_7)
})
