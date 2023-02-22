test_that("Labs assessment can return a correctly assessed data frame for the normal approximation test grouped by the site variable when given correct input data and a site with low enrollment from clindata, and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- gsm::LB_Map_Raw()

  nMinDenominator = 67

  test6_11 <- LB_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    nMinDenominator = nMinDenominator
  )

  # Double Programming
  t6_11_input <- dfInput

  t6_11_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total"
    )

  t6_11_analyzed <- t6_11_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t6_11_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_11_flagged <- t6_11_analyzed %>%
    qualification_flag_normalapprox()

  t6_11_summary <- t6_11_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0))) %>%
    mutate(Score = case_when(Denominator >= nMinDenominator ~ Score,
                             Denominator < nMinDenominator ~ NA_real_),
           Flag = case_when(Denominator >= nMinDenominator ~ Flag,
                            Denominator < nMinDenominator ~ NA_real_))

  t6_11 <- list(
    "dfTransformed" = t6_11_transformed,
    "dfAnalyzed" = t6_11_analyzed,
    "dfFlagged" = t6_11_flagged,
    "dfSummary" = t6_11_summary
  )

  # compare results
  expect_equal(test6_11$lData[!names(test6_11$lData) == "dfBounds"], t6_11)
})
