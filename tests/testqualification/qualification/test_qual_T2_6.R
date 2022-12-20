test_that("PD assessment can return a correctly assessed data frame for the identity test grouped by the site variable and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw()

  test2_6 <- PD_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "CustomGroup"
  )

  # double programming
  t2_6_input <- dfInput

  t2_6_transformed <- dfInput %>%
    qualification_transform_counts(
      GroupID = "CustomGroupID"
    )

  t2_6_analyzed <- t2_6_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t2_6_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t2_6_flagged <- t2_6_analyzed %>%
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
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t2_6_summary <- t2_6_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t2_6 <- list(
    "dfTransformed" = t2_6_transformed,
    "dfAnalyzed" = t2_6_analyzed,
    "dfFlagged" = t2_6_flagged,
    "dfSummary" = t2_6_summary
  )

  # compare results
  expect_equal(test2_6$lData, t2_6)
})
