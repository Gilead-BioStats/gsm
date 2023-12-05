test_that("Given appropriate Labs data, the assessment function correctly performs a Labs Assessment grouped by the Site variable using the Normal Approximation method and correctly assigns Flag variable values when given a custom threshold, and Flag variable values are set to NA for sites with low enrollment.", {
  # gsm analysis
  dfInput <- gsm::LB_Map_Raw()

  nMinDenominator <- 67

  test6_12 <- LB_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    vThreshold = c(-2, -1, 1, 2),
    nMinDenominator = nMinDenominator
  )

  # Double Programming
  t6_12_input <- dfInput

  t6_12_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total"
    )

  t6_12_analyzed <- t6_12_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t6_12_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_12_flagged <- t6_12_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))

  t6_12_summary <- t6_12_flagged %>%
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

  t6_12 <- list(
    "dfTransformed" = t6_12_transformed,
    "dfAnalyzed" = t6_12_analyzed,
    "dfFlagged" = t6_12_flagged,
    "dfSummary" = t6_12_summary
  )

  # compare results
  expect_equal(test6_12$lData[!names(test6_12$lData) %in% c("dfBounds", "dfConfig")], t6_12)
})
