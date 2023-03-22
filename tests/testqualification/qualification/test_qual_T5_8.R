test_that("Given an appropriate subset of Disposition data, the assessment function correctly performs a Disposition Assessment grouped by the Study variable using the Normal Approximation method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::Disp_Map_Raw(dfs = list(
    dfSUBJ = clindata::rawplus_dm,
    dfSTUDCOMP = clindata::rawplus_studcomp %>% filter(compreas_std_nsv == "ID"),
    dfSDRGCOMP = clindata::rawplus_sdrgcomp %>% filter(datapagename ==
                                                         "Blinded Study Drug Completion")
  ))

  test5_8 <- Disp_Assess(
    dfInput = dfInput,
    strGroup = "Study",
    strMethod = "NormalApprox"
  )

  # Double Programming
  t5_8_input <- dfInput

  t5_8_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
      GroupID = "StudyID"
    )

  t5_8_analyzed <- t5_8_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t5_8_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_8_flagged <- t5_8_analyzed %>%
    qualification_flag_normalapprox()

  t5_8_summary <- t5_8_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t5_8 <- list(
    "dfTransformed" = t5_8_transformed,
    "dfAnalyzed" = t5_8_analyzed,
    "dfFlagged" = t5_8_flagged,
    "dfSummary" = t5_8_summary
  )

  # compare results
  expect_equal(test5_8$lData[!names(test5_8$lData) == "dfBounds"], t5_8)
})
