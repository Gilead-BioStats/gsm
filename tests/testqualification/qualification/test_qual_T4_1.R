test_that("Consent assessment can return a correctly assessed data frame grouped by the site variable when given subset input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- Consent_Map_Raw( dfs = list(
    dfSUBJ = clindata::rawplus_dm %>% filter(!siteid %in% c("5", "29", "58")),
    dfCONSENT = clindata::rawplus_consent))

  test4_1 <- Consent_Assess(
    dfInput = dfInput
  )

  # Double Programming
  t4_1_input <- dfInput

  t4_1_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = NA
    )

  t4_1_analyzed <- t4_1_transformed %>%
    mutate(
      Score = TotalCount
    ) %>%
    arrange(Score)

  class(t4_1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t4_1_flagged <- t4_1_analyzed %>%
    mutate(
      Flag = case_when(
        Score > 0.5 ~ 1,
        is.na(Score) ~ NA_real_,
        is.nan(Score) ~ NA_real_,
        TRUE ~ 0
      ),
    ) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t4_1_summary <- t4_1_flagged %>%
    mutate(
      Numerator = NA,
      Denominator = NA
    ) %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t4_1 <- list(
    "dfTransformed" = t4_1_transformed,
    "dfAnalyzed" = t4_1_analyzed,
    "dfFlagged" = t4_1_flagged,
    "dfSummary" = t4_1_summary
  )

  # compare results
  expect_equal(test4_1$lData, t4_1)
})
