test_that("Disposition assessment can return a correctly assessed data frame for the identity test grouped by the site variable when given correct input data and a site with low enrollment from clindata, and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- Disp_Map_Raw()

  nMinDenominator <- 5

  test5_9 <- Disp_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    nMinDenominator = nMinDenominator
  )

  # Double Programming
  t5_9_input <- dfInput

  t5_9_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
    )

  t5_9_analyzed <- t5_9_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t5_9_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_9_flagged <- t5_9_analyzed %>%
    mutate(
      Flag = case_when(
        Score < 3.491 ~ -1,
        Score > 5.172 ~ 1,
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

  t5_9_summary <- t5_9_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0))) %>%
    mutate(Score = case_when(Denominator >= nMinDenominator ~ Score,
                             Denominator < nMinDenominator ~ NA_real_),
           Flag = case_when(Denominator >= nMinDenominator ~ Flag,
                            Denominator < nMinDenominator ~ NA_real_))


  t5_9 <- list(
    "dfTransformed" = t5_9_transformed,
    "dfAnalyzed" = t5_9_analyzed,
    "dfFlagged" = t5_9_flagged,
    "dfSummary" = t5_9_summary
  )

  # compare results
  expect_equal(test5_9$lData, t5_9)
})
