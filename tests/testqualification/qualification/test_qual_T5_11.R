test_that("Disposition assessment can return a correctly assessed data frame for the normal approximation test grouped by the site variable when given correct input data and a site with low enrollment from clindata, and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- gsm::Disp_Map_Raw()

  nMinDenominator <- 5

  test5_11 <- Disp_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    nMinDenominator = nMinDenominator
  )

  # Double Programming
  t5_11_input <- dfInput

  t5_11_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total"
    )

  t5_11_analyzed <- t5_11_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t5_11_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_11_flagged <- t5_11_analyzed %>%
    qualification_flag_normalapprox()

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
  expect_equal(test5_11$lData[!names(test5_11$lData) == "dfBounds"], t5_11)
})
