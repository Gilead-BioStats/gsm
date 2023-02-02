test_that("PD assessment can return a correctly assessed data frame for the identity test grouped by a custom variable when given subset input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Binary(dfs = list(
    dfPD = clindata::rawplus_protdev %>% filter(importnt == "Y"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test27_5 <- PD_Assess_Binary(
    dfInput = dfInput,
    strMethod = "Identity",
    vThreshold = c(0.00001, 0.1),
    strGroup = "Study"
  )

  # double programming
  t27_5_input <- dfInput

  t27_5_transformed <- dfInput %>%
    qualification_transform_counts(
      GroupID = "StudyID",
      exposureCol = "Total"
    )

  t27_5_analyzed <- t27_5_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t27_5_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t27_5_flagged <- t27_5_analyzed %>%
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
        Flag != 0 & Score >= median ~ 1,
        Flag != 0 & Score < median ~ -1,
        TRUE ~ Flag
      )
    ) %>%
    select(-median) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t27_5_summary <- t27_5_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t27_5 <- list(
    "dfTransformed" = t27_5_transformed,
    "dfAnalyzed" = t27_5_analyzed,
    "dfFlagged" = t27_5_flagged,
    "dfSummary" = t27_5_summary
  )

  # compare results
  expect_equal(test27_5$lData, t27_5)
})
