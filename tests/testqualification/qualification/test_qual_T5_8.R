test_that("Disposition assessment can return a correctly assessed data frame for the fisher test grouped by the site variable when given correct input data and a site with low enrollment from clindata, and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- gsm::Disp_Map_Raw()

  nMinDenominator <- 5

  test5_8 <- Disp_Assess(
    dfInput = dfInput,
    strMethod = "Fisher",
    nMinDenominator = nMinDenominator
  )

  # Double Programming
  t5_8_input <- dfInput

  t5_8_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total"
    )

  t5_8_analyzed <- t5_8_transformed %>%
    qualification_analyze_fisher()

  class(t5_8_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_8_flagged <- t5_8_analyzed %>%
    qualification_flag_fisher()

  t5_8_summary <- t5_8_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0))) %>%
    mutate(Score = case_when(Denominator >= nMinDenominator ~ Score,
                             Denominator < nMinDenominator ~ NA_real_),
           Flag = case_when(Denominator >= nMinDenominator ~ Flag,
                            Denominator < nMinDenominator ~ NA_real_))

  t5_8 <- list(
    "dfTransformed" = t5_8_transformed,
    "dfAnalyzed" = t5_8_analyzed,
    "dfFlagged" = t5_8_flagged,
    "dfSummary" = t5_8_summary
  )

  # compare results
  expect_equal(test5_8$lData, t5_8)
})
