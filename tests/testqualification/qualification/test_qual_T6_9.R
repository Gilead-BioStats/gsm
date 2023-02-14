test_that("Labs assessment can return a correctly assessed data frame for the fisher test grouped by the site variable when given correct input data and a site with low enrollment from clindata, and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- gsm::LB_Map_Raw()

  nMinDenominator <- 67

  test6_9 <- LB_Assess(
    dfInput = dfInput,
    strMethod = "Fisher",
    nMinDenominator = nMinDenominator
  )

  # Double Programming
  t6_9_input <- dfInput

  t6_9_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total"
    )

  t6_9_analyzed <- t6_9_transformed %>%
    qualification_analyze_fisher()

  class(t6_9_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_9_flagged <- t6_9_analyzed %>%
    qualification_flag_fisher()

  t6_9_summary <- t6_9_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0))) %>%
    mutate(Score = case_when(Denominator >= nMinDenominator ~ Score,
                             Denominator < nMinDenominator ~ NA_real_),
           Flag = case_when(Denominator >= nMinDenominator ~ Flag,
                            Denominator < nMinDenominator ~ NA_real_))

  t6_9 <- list(
    "dfTransformed" = t6_9_transformed,
    "dfAnalyzed" = t6_9_analyzed,
    "dfFlagged" = t6_9_flagged,
    "dfSummary" = t6_9_summary
  )

  # compare results
  expect_equal(test6_9$lData, t6_9)
})
