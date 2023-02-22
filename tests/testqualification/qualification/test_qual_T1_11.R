test_that("AE assessment can return a correctly assessed data frame for the identity test grouped by the site variable when given correct input data and a site with low enrollment from safetyData, from safetyData and the results should be flagged correctly.", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Raw()

  nMinDenominator <- 5

  test1_11 <- AE_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    nMinDenominator = nMinDenominator
  )

  # double programming
  t1_11_input <- dfInput

  t1_11_transformed <- dfInput %>%
    qualification_transform_counts()

  t1_11_analyzed <- t1_11_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t1_11_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t1_11_flagged <- t1_11_analyzed %>%
    mutate(
      Flag = case_when(
        Score < 0.00006 ~ -1,
        Score > 0.01 ~ 1,
        is.na(Score) ~ NA_real_,
        is.nan(Score) ~ NA_real_,
        TRUE ~ 0
      ),
      median = median(Score),
      Flag = case_when(
        Flag != 0 & Score < median ~ -1,
        Flag != 0 & Score >= median ~ 1,
        TRUE ~ Flag
      )
    ) %>%
    select(-median) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t1_11_summary <- t1_11_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0))) %>%
    mutate(Score = case_when(Denominator >= nMinDenominator ~ Score,
                             Denominator < nMinDenominator ~ NA_real_),
           Flag = case_when(Denominator >= nMinDenominator ~ Flag,
                            Denominator < nMinDenominator ~ NA_real_))


  t1_11 <- list(
    "dfTransformed" = t1_11_transformed,
    "dfAnalyzed" = t1_11_analyzed,
    "dfFlagged" = t1_11_flagged,
    "dfSummary" = t1_11_summary
  )

  # compare results
  expect_equal(test1_11$lData, t1_11)
})
