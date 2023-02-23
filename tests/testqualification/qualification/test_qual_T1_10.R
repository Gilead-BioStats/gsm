test_that("Given appropriate Adverse Event data, the assessment function correctly performs an Adverse Event Assessment grouped by the Site variable using the Poisson method and correctly assigns the Flag variable as NA for sites with low enrollment.", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Raw()

  nMinDenominator <- 5

  test1_10 <- AE_Assess(
    dfInput = dfInput,
    strMethod = "Poisson",
    nMinDenominator = nMinDenominator
  )

  # Double Programming
  t1_10_input <- dfInput

  t1_10_transformed <- dfInput %>%
    qualification_transform_counts()

  t1_10_analyzed <- t1_10_transformed %>%
    qualification_analyze_poisson()

  class(t1_10_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t1_10_flagged <- t1_10_analyzed %>%
    qualification_flag_poisson()

  t1_10_summary <- t1_10_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0))) %>%
    mutate(Score = case_when(Denominator >= nMinDenominator ~ Score,
                             Denominator < nMinDenominator ~ NA_real_),
           Flag = case_when(Denominator >= nMinDenominator ~ Flag,
                             Denominator < nMinDenominator ~ NA_real_))

  T1_10 <- list(
    "dfTransformed" = t1_10_transformed,
    "dfAnalyzed" = t1_10_analyzed,
    "dfFlagged" = t1_10_flagged,
    "dfSummary" = t1_10_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test1_10$lData[names(test1_10$lData) != "dfBounds"], T1_10)
})
