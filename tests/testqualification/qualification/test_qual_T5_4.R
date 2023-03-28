test_that("Given an appropriate subset of Disposition data, the assessment function correctly performs a Disposition Assessment grouped by the Site variable using the Identity method and correctly assigns Flag variable values when given a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::Disp_Map_Raw(dfs = list(
    dfSUBJ = clindata::rawplus_dm,
    dfSTUDCOMP = clindata::rawplus_studcomp %>% filter(compreas_std_nsv == "ID"),
    dfSDRGCOMP = clindata::rawplus_sdrgcomp %>% filter(datapagename ==
      "Blinded Study Drug Completion")
  ))

  test5_4 <- Disp_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    vThreshold = c(2.31, 6.58)
  )

  # Double Programming
  t5_4_input <- dfInput

  t5_4_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
    )

  t5_4_analyzed <- t5_4_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t5_4_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_4_flagged <- t5_4_analyzed %>%
    qualification_flag_identity(threshold = c(2.31, 6.58))

  t5_4_summary <- t5_4_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t5_4 <- list(
    "dfTransformed" = t5_4_transformed,
    "dfAnalyzed" = t5_4_analyzed,
    "dfFlagged" = t5_4_flagged,
    "dfSummary" = t5_4_summary
  )

  # compare results
  expect_equal(test5_4$lData, t5_4)
})
