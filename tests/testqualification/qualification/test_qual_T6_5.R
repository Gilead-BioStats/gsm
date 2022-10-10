test_that("Labs assessment can return a correctly assessed data frame grouped by a custom variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- LB_Map_Raw()

  test6_5 <- LB_Assess(
    dfInput = dfInput,
    strMethod = "identity",
    strGroup = "CustomGroup",
    vThreshold = c(2.31, 6.58)
  )

  # Double Programming
  t6_5_input <- dfInput

  t6_5_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
      GroupID = "CustomGroupID"
    )

  t6_5_analyzed <- t6_5_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t6_5_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_5_flagged <- t6_5_analyzed %>%
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
    arrange(match(Flag, c(1, -1, 0)))

  t6_5_summary <- t6_5_flagged %>%
    select(GroupID, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t6_5 <- list(
    "dfTransformed" = t6_5_transformed,
    "dfAnalyzed" = t6_5_analyzed,
    "dfFlagged" = t6_5_flagged,
    "dfSummary" = t6_5_summary
  )

  # compare results
  expect_equal(test6_5$lData, t6_5)
})
