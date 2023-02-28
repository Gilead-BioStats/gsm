test_that("Given appropriate Labs data, the assessment function correctly performs a Labs Assessment grouped by the Site variable using the Identity method and correctly assigns the Flag variable as NA for sites with low enrollment.", {
  # gsm analysis
  dfInput <- LB_Map_Raw()

  nMinDenominator <- 67

  test6_10 <- LB_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    nMinDenominator = nMinDenominator
  )

  # Double Programming
  t6_10_input <- dfInput

  t6_10_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total"
    )

  t6_10_analyzed <- t6_10_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t6_10_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_10_flagged <- t6_10_analyzed %>%
    mutate(
      Flag = case_when(
        Score < 3.491 ~ -1,
        Score > 5.172 ~ 1,
        is.na(Score) ~ NA_real_,
        is.nan(Score) ~ NA_real_,
        TRUE ~ 0
      ),
      median = median(Metric),
      Flag = case_when(
        Flag != 0 & Metric < median ~ -1,
        Flag != 0 & Metric >= median ~ 1,
        TRUE ~ Flag
      )
    ) %>%
    select(-median) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t6_10_summary <- t6_10_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0))) %>%
    mutate(Score = case_when(Denominator >= nMinDenominator ~ Score,
                             Denominator < nMinDenominator ~ NA_real_),
           Flag = case_when(Denominator >= nMinDenominator ~ Flag,
                            Denominator < nMinDenominator ~ NA_real_))

  t6_10 <- list(
    "dfTransformed" = t6_10_transformed,
    "dfAnalyzed" = t6_10_analyzed,
    "dfFlagged" = t6_10_flagged,
    "dfSummary" = t6_10_summary
  )

  # compare results
  expect_equal(test6_10$lData, t6_10)
})
