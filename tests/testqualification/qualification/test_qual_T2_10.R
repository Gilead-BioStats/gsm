test_that("Given appropriate Protocol Deviation data, the assessment function correctly performs a Protocol Deviation Assessment grouped by the Site variable using the Poisson method and correctly assigns Flag variable values when given a custom threshold, and Flag variable values are set to NA for sites with low enrollment.", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Rate()

  nMinDenominator <- 54

  test2_10 <- PD_Assess_Rate(
    dfInput = dfInput,
    strMethod = "Poisson",
    vThreshold = c(-3, -1, 1, 3),
    nMinDenominator = nMinDenominator
  )

  # Double Programming
  t2_10_input <- dfInput

  t2_10_transformed <- dfInput %>%
    qualification_transform_counts()

  t2_10_analyzed <- t2_10_transformed %>%
    qualification_analyze_poisson()

  class(t2_10_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t2_10_flagged <- t2_10_analyzed %>%
    qualification_flag_poisson(threshold = c(-3, -1, 1, 3))

  t2_10_summary <- t2_10_flagged %>%
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


  t2_10 <- list(
    "dfTransformed" = t2_10_transformed,
    "dfAnalyzed" = t2_10_analyzed,
    "dfFlagged" = t2_10_flagged,
    "dfSummary" = t2_10_summary
  )

  # compare results
  # remove bounds dataframe for now
  expect_equal(test2_10$lData[!names(test2_10$lData) %in% c("dfBounds", "dfConfig")], t2_10)
})
