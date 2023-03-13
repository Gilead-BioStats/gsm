test_that("Given an appropriate subset of Protocol Deviation data, the assessment function correctly performs a Protocol Deviation Assessment grouped by the Study variable using the Normal Approximation method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Binary(dfs = list(
    dfPD = clindata::rawplus_protdev %>% dplyr::filter(importnt == "Y"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test23_8 <- PD_Assess_Binary(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "Study"
  )

  # Double Programming
  t23_8_input <- dfInput

  t23_8_transformed <- dfInput %>%
    qualification_transform_counts(
      GroupID = "StudyID",
      exposureCol = "Total"
    )

  t23_8_analyzed <- t23_8_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t23_8_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t23_8_flagged <- t23_8_analyzed %>%
    qualification_flag_normalapprox()

  t23_8_summary <- t23_8_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t23_8 <- list(
    "dfTransformed" = t23_8_transformed,
    "dfAnalyzed" = t23_8_analyzed,
    "dfFlagged" = t23_8_flagged,
    "dfSummary" = t23_8_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test23_8$lData[names(test23_8$lData) != "dfBounds"], t23_8)
})
