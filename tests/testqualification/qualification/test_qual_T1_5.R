test_that("Given an appropriate subset of Adverse Event data, the assessment function correctly performs an Adverse Event Assessment grouped by the Study variable using the Identity method and correctly assigns Flag variable values when given a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::AE_Map_Raw(dfs = list(
    dfAE = clindata::rawplus_ae %>% filter(aeser_std_nsv == "Y"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test1_5 <- AE_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    vThreshold = c(0.00001, 0.1),
    strGroup = "Study"
  )

  # double programming
  t1_5_input <- dfInput

  t1_5_transformed <- dfInput %>%
    qualification_transform_counts(
      GroupID = "StudyID"
    )

  t1_5_analyzed <- t1_5_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t1_5_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t1_5_flagged <- t1_5_analyzed %>%
    mutate(
      Flag = case_when(
        Score < 0.00001 ~ -1,
        Score > 0.1 ~ 1,
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

  t1_5_summary <- t1_5_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t1_5 <- list(
    "dfTransformed" = t1_5_transformed,
    "dfAnalyzed" = t1_5_analyzed,
    "dfFlagged" = t1_5_flagged,
    "dfSummary" = t1_5_summary
  )

  # compare results
  expect_equal(test1_5$lData, t1_5)
})
