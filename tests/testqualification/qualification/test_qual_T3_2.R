test_that("IE assessment can return a correctly assessed data frame grouped by the study variable when given subset input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- IE_Map_Raw()

  test3_2 <- IE_Assess(
    dfInput = dfInput,
    nThreshold = 1.5,
    strGroup = "Study"
  )

  # Double Programming
  t3_2_input <- dfInput

  t3_2_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = NA,
      GroupID = "StudyID"
    )

  t3_2_analyzed <- t3_2_transformed %>%
    mutate(
      Score = TotalCount
    ) %>%
    arrange(Score)

  class(t3_2_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t3_2_flagged <- t3_2_analyzed %>%
    mutate(
      Flag = case_when(
        Score > 1.5 ~ 1,
        is.na(Score) ~ NA_real_,
        is.nan(Score) ~ NA_real_,
        TRUE ~ 0
      ),
    ) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t3_2_summary <- t3_2_flagged %>%
    mutate(
      Numerator = NA,
      Denominator = NA,
    ) %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t3_2 <- list(
    "dfTransformed" = t3_2_transformed,
    "dfAnalyzed" = t3_2_analyzed,
    "dfFlagged" = t3_2_flagged,
    "dfSummary" = t3_2_summary
  )

  # compare results
  expect_equal(test3_2$lData, t3_2)
})
