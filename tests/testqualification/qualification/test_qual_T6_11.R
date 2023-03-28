test_that("Given appropriate Labs data, the assessment function correctly performs a Labs Assessment grouped by the Site variable using the Identity method and correctly assigns Flag variable values when given a custom threshold, and Flag variable values are set to NA for sites with low enrollment.", {
  # gsm analysis
  dfInput <- LB_Map_Raw()

  nMinDenominator <- 67

  test6_11 <- LB_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    vThreshold = c(2.31, 6.58),
    nMinDenominator = nMinDenominator
  )

  # Double Programming
  t6_11_input <- dfInput

  t6_11_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total"
    )

  t6_11_analyzed <- t6_11_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t6_11_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_11_flagged <- t6_11_analyzed %>%
    qualification_flag_identity(threshold = c(2.31, 6.58))

  t6_11_summary <- t6_11_flagged %>%
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

  t6_11 <- list(
    "dfTransformed" = t6_11_transformed,
    "dfAnalyzed" = t6_11_analyzed,
    "dfFlagged" = t6_11_flagged,
    "dfSummary" = t6_11_summary
  )

  # compare results
  expect_equal(test6_11$lData, t6_11)
})
