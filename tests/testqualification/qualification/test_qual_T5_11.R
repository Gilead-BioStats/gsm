test_that("Given appropriate Disposition data, the assessment function correctly performs a Disposition Assessment grouped by the Site variable using the Identity method and correctly assigns Flag variable values when given a custom threshold, and Flag variable values are set to NA for sites with low enrollment.", {

  # gsm analysis
  dfInput <- Disp_Map_Raw()

  nMinDenominator <- 5

  test5_11 <- Disp_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    vThreshold = c(2.31, 6.58),
    nMinDenominator = nMinDenominator
  )

  # Double Programming
  t5_11_input <- dfInput

  t5_11_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
    )

  t5_11_analyzed <- t5_11_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t5_11_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_11_flagged <- t5_11_analyzed %>%
    qualification_flag_identity(threshold = c(2.31, 6.58))

  t5_11_summary <- t5_11_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0))) %>%
    mutate(Score = case_when(Denominator >= nMinDenominator ~ Score,
                             Denominator < nMinDenominator ~ NA_real_),
           Flag = case_when(Denominator >= nMinDenominator ~ Flag,
                            Denominator < nMinDenominator ~ NA_real_))


  t5_11 <- list(
    "dfTransformed" = t5_11_transformed,
    "dfAnalyzed" = t5_11_analyzed,
    "dfFlagged" = t5_11_flagged,
    "dfSummary" = t5_11_summary
  )

  # compare results
  expect_equal(test5_11$lData, t5_11)
})
