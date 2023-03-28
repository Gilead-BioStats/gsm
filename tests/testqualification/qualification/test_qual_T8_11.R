test_that("Given appropriate Data Entry Lag data, the assessment function correctly performs a Data Entry Lag Assessment grouped by the Site variable using the Identity method and correctly assigns Flag variable values when given a custom threshold, and Flag variable values are set to NA for sites with low enrollment.", {
  # gsm analysis
  dfInput <- gsm::DataEntry_Map_Raw()

  nMinDenominator <- 24

  test8_11 <- DataEntry_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "Site",
    vThreshold = c(0.00006, 0.01),
    nMinDenominator = nMinDenominator
  )

  # double programming
  t8_11_input <- dfInput

  t8_11_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total"
    )

  t8_11_analyzed <- t8_11_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t8_11_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t8_11_flagged <- t8_11_analyzed %>%
    qualification_flag_identity(threshold = c(0.00006, 0.01))

  t8_11_summary <- t8_11_flagged %>%
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


  t8_11 <- list(
    "dfTransformed" = t8_11_transformed,
    "dfAnalyzed" = t8_11_analyzed,
    "dfFlagged" = t8_11_flagged,
    "dfSummary" = t8_11_summary
  )

  # compare results
  expect_equal(test8_11$lData, t8_11)
})
