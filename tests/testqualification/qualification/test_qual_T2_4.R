test_that("PD assessment can return a correctly assessed data frame for the identity test grouped by the site variable when given correct input data from clindata and the results should be flagged correctly using a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw()

  test2_4 <- PD_Assess(
    dfInput = dfInput,
    strMethod = "Identity"
  )

  # double programming
  t2_4_input <- dfInput

  t2_4_transformed <- dfInput %>%
    qualification_transform_counts()

  t2_4_analyzed <- t2_4_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t2_4_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t2_4_flagged <- t2_4_analyzed %>%
    mutate(
      Flag = case_when(
        Score < 0.000895 ~ -1,
        Score > 0.003059 ~ 1,
        is.na(Score) ~ NA_real_,
        is.nan(Score) ~ NA_real_,
        TRUE ~ 0
      ),
      median = median(Score),
      Flag = case_when(
        Flag != 0 & Score >= median ~ 1,
        Flag != 0 & Score < median ~ -1,
        TRUE ~ Flag
      )
    ) %>%
    select(-median) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t2_4_summary <- t2_4_flagged %>%
    select(GroupID, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t2_4 <- list(
    "dfTransformed" = t2_4_transformed,
    "dfAnalyzed" = t2_4_analyzed,
    "dfFlagged" = t2_4_flagged,
    "dfSummary" = t2_4_summary
  )

  # compare results
  expect_equal(test2_4$lData, t2_4)
})
