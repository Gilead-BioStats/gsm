test_that("Given an appropriate subset of Disposition data, the assessment function correctly performs a Disposition Assessment grouped by a custom variable using the Fisher method and correctly assigns Flag variable values when given a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::Disp_Map_Raw(dfs = list(
    dfSUBJ = clindata::rawplus_dm,
    dfSTUDCOMP = clindata::rawplus_studcomp %>% filter(compreas_std_nsv == "ID"),
    dfSDRGCOMP = clindata::rawplus_sdrgcomp %>% filter(datapagename ==
                                                         "Blinded Study Drug Completion")
  ))

  test5_2 <- Disp_Assess(
    dfInput = dfInput,
    vThreshold = c(.025, .05),
    strGroup = "CustomGroup",
    strMethod = "Fisher"
  )

  # Double Programming
  t5_2_input <- dfInput

  t5_2_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
      GroupID = "CustomGroupID"
    )

  t5_2_analyzed <- t5_2_transformed %>%
    qualification_analyze_fisher()

  class(t5_2_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_2_flagged <- t5_2_analyzed %>%
    qualification_flag_fisher(threshold = c(.025, .05))

  t5_2_summary <- t5_2_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t5_2 <- list(
    "dfTransformed" = t5_2_transformed,
    "dfAnalyzed" = t5_2_analyzed,
    "dfFlagged" = t5_2_flagged,
    "dfSummary" = t5_2_summary
  )

  # compare results
  expect_equal(test5_2$lData, t5_2)
})
