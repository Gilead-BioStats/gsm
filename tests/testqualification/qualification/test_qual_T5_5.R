test_that("Given appropriate Disposition data, the assessment function correctly performs a Disposition Assessment grouped by a custom variable using the Identity method and correctly assigns Flag variable values when given a custom threshold.", {
  # gsm analysis
  dfInput <- Disp_Map_Raw()

  test5_5 <- Disp_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "CustomGroup",
    vThreshold = c(2.31, 6.58)
  )

  # Double Programming
  t5_5_input <- dfInput

  t5_5_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
      GroupID = "CustomGroupID"
    )

  t5_5_analyzed <- t5_5_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t5_5_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_5_flagged <- t5_5_analyzed %>%
    mutate(
      Flag = case_when(
        Score < 2.31 ~ -1,
        Score > 6.58 ~ 1,
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

  t5_5_summary <- t5_5_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t5_5 <- list(
    "dfTransformed" = t5_5_transformed,
    "dfAnalyzed" = t5_5_analyzed,
    "dfFlagged" = t5_5_flagged,
    "dfSummary" = t5_5_summary
  )

  # compare results
  expect_equal(test5_5$lData, t5_5)
})
