test_that("Given an appropriate subset of Labs data, the assessment function correctly performs a Labs Assessment grouped by the Site variable using the Identity method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::LB_Map_Raw(dfs = list(
    dfSUBJ = clindata::rawplus_dm  %>% filter(!siteid %in% c("5", "29", "58")),
    dfLB = clindata::rawplus_lb))

  test6_3 <- LB_Assess(
    dfInput = dfInput,
    strMethod = "Identity"
  )

  # Double Programming
  t6_3_input <- dfInput

  t6_3_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total"
    )

  t6_3_analyzed <- t6_3_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t6_3_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_3_flagged <- t6_3_analyzed %>%
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
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t6_3_summary <- t6_3_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t6_3 <- list(
    "dfTransformed" = t6_3_transformed,
    "dfAnalyzed" = t6_3_analyzed,
    "dfFlagged" = t6_3_flagged,
    "dfSummary" = t6_3_summary
  )

  # compare results
  expect_equal(test6_3$lData, t6_3)
})
