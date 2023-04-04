test_that("Given an appropriate subset of Protocol Deviation data, the assessment function correctly performs a Protocol Deviation Assessment grouped by the Site variable using the Poisson method and correctly assigns Flag variable values  when given a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Binary(dfs = list(
    dfPD = clindata::ctms_protdev %>% filter(DeemedImportant == "Yes"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test23_1 <- PD_Assess_Binary(
    dfInput = dfInput,
    strMethod = "Poisson",
    vThreshold = c(-3, -1, 1, 3)
  )

  # Double Programming
  t23_1_input <- dfInput

  t23_1_transformed <- dfInput %>%
    qualification_transform_counts(exposureCol = "Total")

  t23_1_analyzed <- t23_1_transformed %>%
    qualification_analyze_poisson()

  class(t23_1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t23_1_flagged <- t23_1_analyzed %>%
    qualification_flag_poisson(threshold = c(-3, -1, 1, 3))

  t23_1_summary <- t23_1_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t23_1 <- list(
    "dfTransformed" = t23_1_transformed,
    "dfAnalyzed" = t23_1_analyzed,
    "dfFlagged" = t23_1_flagged,
    "dfSummary" = t23_1_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test23_1$lData[names(test23_1$lData) != "dfBounds"], t23_1)
})
