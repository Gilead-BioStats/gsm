test_that("Disposition assessment can return a correctly assessed data frame for the normal approximation test grouped by the site variable when given correct input data and a site with low enrollment from clindata, and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- gsm::Disp_Map_Raw()

  nMinDenominator <- 5

  test5_10 <- Disp_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    nMinDenominator = nMinDenominator
  )

  # Double Programming
  t5_10_input <- dfInput

  t5_10_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total"
    )

  t5_10_analyzed <- t5_10_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t5_10_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_10_flagged <- t5_10_analyzed %>%
    qualification_flag_normalapprox()

  t5_10_summary <- t5_10_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0))) %>%
    mutate(Score = case_when(Denominator >= nMinDenominator ~ Score,
                             Denominator < nMinDenominator ~ NA_real_),
           Flag = case_when(Denominator >= nMinDenominator ~ Flag,
                            Denominator < nMinDenominator ~ NA_real_))

  t5_10 <- list(
    "dfTransformed" = t5_10_transformed,
    "dfAnalyzed" = t5_10_analyzed,
    "dfFlagged" = t5_10_flagged,
    "dfSummary" = t5_10_summary
  )

  # compare results
  expect_equal(test5_10$lData[!names(test5_10$lData) == "dfBounds"], t5_10)
})
