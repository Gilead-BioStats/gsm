test_that("Given an appropriate subset of Disposition data, the assessment function correctly performs a Disposition Assessment grouped by the Site variable using the Identity method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::Disp_Map_Raw(dfs = list(
    dfSUBJ = clindata::rawplus_dm,
    dfSTUDCOMP = clindata::rawplus_studcomp %>% filter(compreas_std_nsv == "ID"),
    dfSDRGCOMP = clindata::rawplus_sdrgcomp %>% filter(datapagename ==
                                                         "Blinded Study Drug Completion")
  ))

  test5_3 <- Disp_Assess(
    dfInput = dfInput,
    strMethod = "Identity"
  )

  # Double Programming
  t5_3_input <- dfInput

  t5_3_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
    )

  t5_3_analyzed <- t5_3_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t5_3_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_3_flagged <- t5_3_analyzed %>%
    mutate(
      Flag = case_when(
        Score < 3.491 ~ -1,
        Score > 5.172 ~ 1,
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

  t5_3_summary <- t5_3_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t5_3 <- list(
    "dfTransformed" = t5_3_transformed,
    "dfAnalyzed" = t5_3_analyzed,
    "dfFlagged" = t5_3_flagged,
    "dfSummary" = t5_3_summary
  )

  # compare results
  expect_equal(test5_3$lData, t5_3)
})
