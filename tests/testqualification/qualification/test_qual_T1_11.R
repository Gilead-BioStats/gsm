test_that("Given appropriate Adverse Event data, the assessment function correctly performs an Adverse Event Assessment grouped by the Site variable using the Identity method and correctly assigns Flag variable values when given a custom threshold, and Flag variable values are set to NA for sites with low enrollment.", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Raw()

  nMinDenominator <- 5

  test1_11 <- AE_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    vThreshold = c(0.00001, 0.1),
    nMinDenominator = nMinDenominator
  )

  # double programming
  t1_11_input <- dfInput

  t1_11_transformed <- dfInput %>%
    qualification_transform_counts()

  t1_11_analyzed <- t1_11_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t1_11_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t1_11_flagged <- t1_11_analyzed %>%
    qualification_flag_identity(threshold = c(0.00001, 0.1))

  t1_11_summary <- t1_11_flagged %>%
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


  t1_11 <- list(
    "dfTransformed" = t1_11_transformed,
    "dfAnalyzed" = t1_11_analyzed,
    "dfFlagged" = t1_11_flagged,
    "dfSummary" = t1_11_summary
  )

  # remove metadata that is not part of qualification
  test1_11$lData$dfConfig <- NULL

  # compare results
  expect_equal(test1_11$lData, t1_11)
})
