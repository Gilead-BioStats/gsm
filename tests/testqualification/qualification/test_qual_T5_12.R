test_that("Given appropriate Disposition data, the assessment function correctly performs a Disposition Assessment grouped by the Site variable using the Normal Approximation method and correctly assigns Flag variable when given a custom threshold, and Flag variable values are set to NA for sites with low enrollment.", {
  # gsm analysis
  dfInput <- gsm::Disp_Map_Raw()

  nMinDenominator <- 5

  test5_12 <- Disp_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    vThreshold = c(-2, -1, 1, 2),
    nMinDenominator = nMinDenominator
  )

  # Double Programming
  t5_12_input <- dfInput

  t5_12_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total"
    )

  t5_12_analyzed <- t5_12_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t5_12_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_12_flagged <- t5_12_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))

  t5_12_summary <- t5_12_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0))) %>%
    mutate(Score = case_when(Denominator >= nMinDenominator ~ Score,
                             Denominator < nMinDenominator ~ NA_real_),
           Flag = case_when(Denominator >= nMinDenominator ~ Flag,
                            Denominator < nMinDenominator ~ NA_real_))

  t5_12 <- list(
    "dfTransformed" = t5_12_transformed,
    "dfAnalyzed" = t5_12_analyzed,
    "dfFlagged" = t5_12_flagged,
    "dfSummary" = t5_12_summary
  )

  # compare results
  expect_equal(test5_12$lData[!names(test5_12$lData) == "dfBounds"], t5_12)
})
