test_that("Given appropriate Disposition data, the assessment function correctly performs a Disposition Assessment grouped by the Site variable using the Identity method and correctly assigns the Flag variable as NA for sites with low enrollment.", {
  # gsm analysis
  dfInput <- Disp_Map_Raw()

  nMinDenominator <- 5

  test5_10 <- Disp_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    nMinDenominator = nMinDenominator
  )

  # Double Programming
  t5_10_input <- dfInput

  t5_10_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
    )

  t5_10_analyzed <- t5_10_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t5_10_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_10_flagged <- t5_10_analyzed %>%
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
  expect_equal(test5_10$lData, t5_10)
})
