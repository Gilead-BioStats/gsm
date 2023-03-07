test_that("Given appropriate Labs data, the assessment function correctly performs a Labs Assessment grouped by the Site variable using the Fisher method and correctly assigns the Flag variable as NA for sites with low enrollment.", {
  # gsm analysis
  dfInput <- gsm::LB_Map_Raw()

  nMinDenominator <- 67

  test6_9 <- LB_Assess(
    dfInput = dfInput,
    strMethod = "Fisher",
    nMinDenominator = nMinDenominator
  )

  # Double Programming
  t6_9_input <- dfInput

  t6_9_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total"
    )

  t6_9_analyzed <- t6_9_transformed %>%
    qualification_analyze_fisher()

  class(t6_9_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_9_flagged <- t6_9_analyzed %>%
    qualification_flag_fisher()

  t6_9_summary <- t6_9_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0))) %>%
    mutate(Score = case_when(Denominator >= nMinDenominator ~ Score,
                             Denominator < nMinDenominator ~ NA_real_),
           Flag = case_when(Denominator >= nMinDenominator ~ Flag,
                            Denominator < nMinDenominator ~ NA_real_))

  t6_9 <- list(
    "dfTransformed" = t6_9_transformed,
    "dfAnalyzed" = t6_9_analyzed,
    "dfFlagged" = t6_9_flagged,
    "dfSummary" = t6_9_summary
  )

  # compare results
  expect_equal(test6_9$lData, t6_9)
})
