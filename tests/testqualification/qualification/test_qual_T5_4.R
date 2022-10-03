test_that("Disposition assessment can return a correctly assessed data frame for the identity test grouped by the study variable when given correct input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- Disp_Map_Raw()

  test5_4 <- Disp_Assess(
    dfInput = dfInput,
    strMethod = "identity",
    strGroup = "Study"
  )

  # Double Programming
  t5_4_input <- dfInput

  t5_4_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
      GroupID = "StudyID"
    )

  t5_4_analyzed <- t5_4_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t5_4_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_4_flagged <- t5_4_analyzed %>%
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

  t5_4_summary <- t5_4_flagged %>%
    select(GroupID, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t5_4 <- list(
    "dfTransformed" = t5_4_transformed,
    "dfAnalyzed" = t5_4_analyzed,
    "dfFlagged" = t5_4_flagged,
    "dfSummary" = t5_4_summary
  )

  # compare results
  expect_equal(test5_4$lData, t5_4)
})
