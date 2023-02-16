test_that("Consent assessment can return a correctly assessed data frame grouped by the study variable when given subset input data from clindata and the results should be flagged correctly using a custom threshold", {
  # gsm analysis
  dfInput <- Consent_Map_Raw( dfs = list(
    dfSUBJ = clindata::rawplus_dm %>% filter(!siteid %in% c("5", "29", "58")),
    dfCONSENT = clindata::rawplus_consent))

  test4_2 <- Consent_Assess(
    dfInput = dfInput,
    strGroup = "Study",
    nThreshold = 1.5
  )

  # Double Programming
  t4_2_input <- dfInput

  t4_2_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = NA,
      GroupID = "StudyID"
    )

  t4_2_analyzed <- t4_2_transformed %>%
    mutate(
      Score = TotalCount
    ) %>%
    arrange(Score)

  class(t4_2_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t4_2_flagged <- t4_2_analyzed %>%
    mutate(
      Flag = case_when(
        Score > 1.5 ~ 1,
        is.na(Score) ~ NA_real_,
        is.nan(Score) ~ NA_real_,
        TRUE ~ 0
      ),
    ) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t4_2_summary <- t4_2_flagged %>%
    mutate(
      Numerator = NA,
      Denominator = NA
    ) %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t4_2 <- list(
    "dfTransformed" = t4_2_transformed,
    "dfAnalyzed" = t4_2_analyzed,
    "dfFlagged" = t4_2_flagged,
    "dfSummary" = t4_2_summary
  )

  # compare results
  expect_equal(test4_2$lData, t4_2)
})
