test_that("Given an appropriate subset of Adverse Event data, the assessment function correctly performs an Adverse Event Assessment grouped by the Site variable using the Identity method and correctly assigns Flag variable values when given a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Raw(dfs = list(
    dfAE = clindata::rawplus_ae %>% filter(aeser_std_nsv == "Y"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test1_4 <- AE_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    vThreshold = c(0.00001, 0.1)
  )

  # double programming
  t1_4_input <- dfInput

  t1_4_transformed <- dfInput %>%
    qualification_transform_counts()

  t1_4_analyzed <- t1_4_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t1_4_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t1_4_flagged <- t1_4_analyzed %>%
    qualification_flag_identity(threshold = c(0.00001, 0.1))

  t1_4_summary <- t1_4_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t1_4 <- list(
    "dfTransformed" = t1_4_transformed,
    "dfAnalyzed" = t1_4_analyzed,
    "dfFlagged" = t1_4_flagged,
    "dfSummary" = t1_4_summary
  )

  # compare results
  expect_equal(test1_4$lData, t1_4)
})
