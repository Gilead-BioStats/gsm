test_that("Given appropriate Query Age data, the assessment function correctly performs a Query Age Assessment grouped by the Site variable using the Identity method and correctly assigns Flag variable values when given a custom threshold, and Flag variable values are set to NA for sites with low enrollment.", {
  # gsm analysis
  dfInput <- gsm::QueryAge_Map_Raw()

  nMinDenominator <- 10

  test9_11 <- QueryAge_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "Site",
    vThreshold = c(0.00006, 0.01),
    nMinDenominator = nMinDenominator
  )

  # double programming
  t9_11_input <- dfInput

  t9_11_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "Total"
    )

  t9_11_analyzed <- t9_11_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t9_11_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t9_11_flagged <- t9_11_analyzed %>%
    qualification_flag_identity(threshold = c(0.00006, 0.01))

  t9_11_summary <- t9_11_flagged %>%
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



  t9_11 <- list(
    "dfTransformed" = t9_11_transformed,
    "dfAnalyzed" = t9_11_analyzed,
    "dfFlagged" = t9_11_flagged,
    "dfSummary" = t9_11_summary
  )

  # compare results
  expect_equal(test9_11$lData, t9_11)
})
