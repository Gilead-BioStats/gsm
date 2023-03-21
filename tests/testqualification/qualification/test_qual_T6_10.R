test_that("Given appropriate Labs data, the assessment function correctly performs a Labs Assessment grouped by the Site variable using the Fisher method and correctly assigns Flag variable values when given a custom threshold, and Flag variable values are set to NA for sites with low enrollment.", {
  # gsm analysis
  dfInput <- gsm::LB_Map_Raw()

  nMinDenominator <- 67

  test6_10 <- LB_Assess(
    dfInput = dfInput,
    strMethod = "Fisher",
    vThreshold = c(.025, .05),
    nMinDenominator = nMinDenominator
  )

  # Double Programming
  t6_10_input <- dfInput

  t6_10_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total"
    )

  t6_10_analyzed <- t6_10_transformed %>%
    qualification_analyze_fisher()

  class(t6_10_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_10_flagged <- t6_10_analyzed %>%
    qualification_flag_fisher(threshold = c(.025, .05))

  t6_10_summary <- t6_10_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0))) %>%
    mutate(
      Score = case_when(
        Denominator >= nMinDenominator ~ Score,
        Denominator < nMinDenominator ~ NA_real_
      ),
      Flag = case_when(
        Denominator >= nMinDenominator ~ Flag,
        Denominator < nMinDenominator ~ NA_real_
      )
    )

  t6_10 <- list(
    "dfTransformed" = t6_10_transformed,
    "dfAnalyzed" = t6_10_analyzed,
    "dfFlagged" = t6_10_flagged,
    "dfSummary" = t6_10_summary
  )

  # compare results
  expect_equal(test6_10$lData, t6_10)
})
