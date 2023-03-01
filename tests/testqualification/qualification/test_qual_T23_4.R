test_that("Given an appropriate subset of Protocol Deviation data, the assessment function correctly performs a Protocol Deviation Assessment grouped by the Site variable using the Identity method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Binary(dfs = list(
    dfPD = clindata::rawplus_protdev %>% dplyr::filter(importnt == "Y"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test23_4 <- PD_Assess_Binary(
    dfInput = dfInput,
    strMethod = "Identity"
  )

  # double programming
  t23_4_input <- dfInput

  t23_4_transformed <- dfInput %>%
    qualification_transform_counts(exposureCol = "Total")

  t23_4_analyzed <- t23_4_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t23_4_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t23_4_flagged <- t23_4_analyzed %>%
    qualification_flag_identity()

  t23_4_summary <- t23_4_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t23_4 <- list(
    "dfTransformed" = t23_4_transformed,
    "dfAnalyzed" = t23_4_analyzed,
    "dfFlagged" = t23_4_flagged,
    "dfSummary" = t23_4_summary
  )

  # compare results
  expect_equal(test23_4$lData, t23_4)
})
