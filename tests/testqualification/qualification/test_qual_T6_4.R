test_that("Labs assessment can return a correctly assessed data frame grouped by the study variable when given correct input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- LB_Map_Raw()

  test6_4 <- LB_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "Study"
  )

  # Double Programming
  t6_4_input <- dfInput

  t6_4_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
      GroupID = "StudyID"
    )

  t6_4_analyzed <- t6_4_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t6_4_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_4_flagged <- t6_4_analyzed %>%
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
    arrange(match(Flag, c(1, -1, 0)))

  t6_4_summary <- t6_4_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t6_4 <- list(
    "dfTransformed" = t6_4_transformed,
    "dfAnalyzed" = t6_4_analyzed,
    "dfFlagged" = t6_4_flagged,
    "dfSummary" = t6_4_summary
  )

  # compare results
  expect_equal(test6_4$lData, t6_4)
})
