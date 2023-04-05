test_that("Given appropriate Adverse Event data, the assessment function correctly performs an Adverse Event Assessment grouped by the Site variable using the Normal Approximation method and correctly assigns Flag variable values when given a custom threshold, and Flag variable values are set to NA for sites with low enrollment.", {
  dfInput <- gsm::AE_Map_Raw()

  nMinDenominator <- 5

  test1_12 <- AE_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox",
    vThreshold = c(-3, -1, 1, 3),
    nMinDenominator = nMinDenominator
  )


  # Double Programming
  t1_12_input <- dfInput

  t1_12_transformed <- dfInput %>%
    qualification_transform_counts()

  t1_12_analyzed <- t1_12_transformed %>%
    qualification_analyze_normalapprox(strType = "rate")

  class(t1_12_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t1_12_flagged <- t1_12_analyzed %>%
    qualification_flag_normalapprox(threshold = c(-3, -1, 1, 3))

  t1_12_summary <- t1_12_flagged %>%
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


  t1_12 <- list(
    "dfTransformed" = t1_12_transformed,
    "dfAnalyzed" = t1_12_analyzed,
    "dfFlagged" = t1_12_flagged %>% arrange(match(Flag, c(2, -2, 1, -1, 0))),
    "dfSummary" = t1_12_summary
  )

  expect_equal(test1_12$lData[names(test1_12$lData) != "dfBounds"], t1_12)
})
