test_that("AE assessment can return a correctly assessed data frame for the identity test grouped by a custom variable when given subset input data from clindata and the results should be flagged correctly.", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Raw(dfs = list(
    dfAE = clindata::rawplus_ae %>% filter(aeser_std_nsv == "Y"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test1_6 <- AE_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "CustomGroup"
  )

  # double programming
  t1_6_input <- dfInput

  t1_6_transformed <- dfInput %>%
    qualification_transform_counts(
      GroupID = "CustomGroupID"
    )

  t1_6_analyzed <- t1_6_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t1_6_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t1_6_flagged <- t1_6_analyzed %>%
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
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t1_6_summary <- t1_6_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t1_6 <- list(
    "dfTransformed" = t1_6_transformed,
    "dfAnalyzed" = t1_6_analyzed,
    "dfFlagged" = t1_6_flagged,
    "dfSummary" = t1_6_summary
  )

  # compare results
  expect_equal(test1_6$lData, t1_6)
})
