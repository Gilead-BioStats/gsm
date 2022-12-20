test_that("Labs assessment can return a correctly assessed data frame grouped by the site variable when given correct input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- LB_Map_Raw()

  test6_3 <- LB_Assess(
    dfInput = dfInput,
    strMethod = "Identity"
  )

  # Double Programming
  t6_3_input <- dfInput

  t6_3_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total"
    )

  t6_3_analyzed <- t6_3_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t6_3_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_3_flagged <- t6_3_analyzed %>%
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

  t6_3_summary <- t6_3_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t6_3 <- list(
    "dfTransformed" = t6_3_transformed,
    "dfAnalyzed" = t6_3_analyzed,
    "dfFlagged" = t6_3_flagged,
    "dfSummary" = t6_3_summary
  )

  # compare results
  expect_equal(test6_3$lData, t6_3)
})
