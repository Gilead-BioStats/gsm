test_that("Query age assessment can return a correctly assessed data frame for the normal approximation test grouped by the site variable when given correct input data and a site with low enrollment from clindata, and the results should be flagged correctly using a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::QueryAge_Map_Raw()

  nMinDenominator <- 10

  test9_12 <- QueryAge_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    strGroup = "Site",
    vThreshold = c(-2, -1, 1, 2),
    nMinDenominator = nMinDenominator
  )

  # double programming
  t9_12_input <- dfInput

  t9_12_transformed <- dfInput %>%
    qualification_transform_counts(countCol = "Count",
                                   exposureCol = "Total")

  t9_12_analyzed <- t9_12_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t9_12_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t9_12_flagged <- t9_12_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-2, -1, 1, 2))

  t9_12_summary <- t9_12_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0))) %>%
    mutate(Score = case_when(Denominator >= nMinDenominator ~ Score,
                             Denominator < nMinDenominator ~ NA_real_),
           Flag = case_when(Denominator >= nMinDenominator ~ Flag,
                            Denominator < nMinDenominator ~ NA_real_))


  t9_12 <- list(
    "dfTransformed" = t9_12_transformed,
    "dfAnalyzed" = t9_12_analyzed,
    "dfFlagged" = t9_12_flagged,
    "dfSummary" = t9_12_summary
  )

  # compare results
  expect_equal(test9_12$lData[names(test9_12$lData) != "dfBounds"], t9_12)
})
