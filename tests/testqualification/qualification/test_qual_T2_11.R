test_that("Given appropriate Protocol Deviation data, the assessment function correctly performs a Protocol Deviation Assessment grouped by the Site variable using the Identity method and correctly assigns Flag variable values when given a custom threshold, and Flag variable values are set to NA for sites with low enrollment.", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Rate()

  nMinDenominator <- 54

  test2_11 <- PD_Assess_Rate(
    dfInput = dfInput,
    strMethod = "Identity",
    vThreshold = c(0.00001, 0.1),
    nMinDenominator = nMinDenominator
  )

  # double programming
  t2_11_input <- dfInput

  t2_11_transformed <- dfInput %>%
    qualification_transform_counts()

  t2_11_analyzed <- t2_11_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t2_11_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t2_11_flagged <- t2_11_analyzed %>%
    qualification_flag_identity(threshold = c(0.00001, 0.1))

  t2_11_summary <- t2_11_flagged %>%
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

  t2_11 <- list(
    "dfTransformed" = t2_11_transformed,
    "dfAnalyzed" = t2_11_analyzed,
    "dfFlagged" = t2_11_flagged,
    "dfSummary" = t2_11_summary
  )

  # compare results
  expect_equal(test2_11$lData, t2_11)
})
