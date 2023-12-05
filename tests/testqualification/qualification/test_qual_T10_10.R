test_that("Given appropriate Query Rate data, the assessment function correctly performs a Query Rate Assessment grouped by the Site variable using the Poisson method and correctly assigns Flag variable values when given a custom threshold, and Flag variable values are set to NA for sites with low enrollment.", {
  # gsm analysis
  dfInput <- gsm::QueryRate_Map_Raw()

  nMinDenominator <- 196

  test10_10 <- QueryRate_Assess(
    dfInput = dfInput,
    strMethod = "Poisson",
    strGroup = "Site",
    vThreshold = c(-6, -4, 4, 6),
    nMinDenominator = nMinDenominator
  )

  # double programming
  t10_10_input <- dfInput

  t10_10_transformed <- dfInput %>%
    qualification_transform_counts(
      countCol = "Count",
      exposureCol = "DataPoint"
    )

  t10_10_analyzed <- t10_10_transformed %>%
    qualification_analyze_poisson()

  class(t10_10_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t10_10_flagged <- t10_10_analyzed %>%
    qualification_flag_poisson(threshold = c(-6, -4, 4, 6))

  t10_10_summary <- t10_10_flagged %>%
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


  t10_10 <- list(
    "dfTransformed" = t10_10_transformed,
    "dfAnalyzed" = t10_10_analyzed,
    "dfFlagged" = t10_10_flagged,
    "dfSummary" = t10_10_summary
  )

  # compare results
  expect_equal(test10_10$lData[!names(test10_10$lData) %in% c("dfBounds", "dfConfig")], t10_10)
})
