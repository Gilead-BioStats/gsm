test_that("Given appropriate Consent data, the assessment function correctly performs a Consent Assessment grouped by a custom variable using the Identity method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- Consent_Map_Raw()

  test4_3 <- Consent_Assess(
    dfInput = dfInput,
    strGroup = "CustomGroup"
  )

  # Double Programming
  t4_3_input <- dfInput

  t4_3_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = NA,
      GroupID = "CustomGroupID"
    )

  t4_3_analyzed <- t4_3_transformed %>%
    mutate(
      Score = TotalCount
    ) %>%
    arrange(Score)

  class(t4_3_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t4_3_flagged <- t4_3_analyzed %>%
    mutate(
      Flag = case_when(
        Score > 0.5 ~ 1,
        is.na(Score) ~ NA_real_,
        is.nan(Score) ~ NA_real_,
        TRUE ~ 0
      ),
    ) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t4_3_summary <- t4_3_flagged %>%
    mutate(
      Numerator = NA,
      Denominator = NA
    ) %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t4_3 <- list(
    "dfTransformed" = t4_3_transformed,
    "dfAnalyzed" = t4_3_analyzed,
    "dfFlagged" = t4_3_flagged,
    "dfSummary" = t4_3_summary
  )

  # compare results
  expect_equal(test4_3$lData, t4_3)
})
