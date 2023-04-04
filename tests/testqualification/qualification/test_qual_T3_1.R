test_that("Given appropriate  Inclusion/Exclusion data, the assessment function correctly performs an Inclusion/Exclusion Assessment grouped by the Site variable using the Identity method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- IE_Map_Raw()

  test3_1 <- IE_Assess(
    dfInput = dfInput
  )

  # Double Programming
  t3_1_input <- dfInput

  t3_1_transformed <- dfInput %>%
    qualification_transform_counts(exposureCol = NA)

  t3_1_analyzed <- t3_1_transformed %>%
    mutate(
      Score = TotalCount
    ) %>%
    arrange(Score)

  class(t3_1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t3_1_flagged <- t3_1_analyzed %>%
    mutate(
      Flag = case_when(
        Score > 0.5 ~ 1,
        is.na(Score) ~ NA_real_,
        is.nan(Score) ~ NA_real_,
        TRUE ~ 0
      ),
    ) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t3_1_summary <- t3_1_flagged %>%
    mutate(
      Numerator = NA,
      Denominator = NA
    ) %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t3_1 <- list(
    "dfTransformed" = t3_1_transformed,
    "dfAnalyzed" = t3_1_analyzed,
    "dfFlagged" = t3_1_flagged,
    "dfSummary" = t3_1_summary
  )

  # compare results
  expect_equal(test3_1$lData, t3_1)
})
