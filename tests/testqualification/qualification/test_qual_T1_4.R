test_that("AE assessment can return a correctly assessed data frame for the identity test grouped by the site variable when given correct input data from safetyData and the results should be flagged correctly.", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Adam()

  test1_4 <- AE_Assess(
    dfInput = dfInput,
    strMethod = "identity"
  )

  # double programming
  t1_4_input <- dfInput

  t1_4_transformed <- dfInput %>%
    qualification_transform_counts()

  t1_4_analyzed <- t1_4_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t1_4_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t1_4_flagged <- t1_4_analyzed %>%
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
    arrange(match(Flag, c(1, -1, 0)))

  t1_4_summary <- t1_4_flagged %>%
    select(GroupID, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(1, -1, 0)))


  t1_4 <- list(
    "dfTransformed" = t1_4_transformed,
    "dfAnalyzed" = t1_4_analyzed,
    "dfFlagged" = t1_4_flagged,
    "dfSummary" = t1_4_summary
  )

  # compare results
  expect_equal(test1_4$lData, t1_4)
})
