test_that("PD assessment can return a correctly assessed data frame for the identity test grouped by a custom variable when given subset input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Binary(dfs = list(
    dfPD = clindata::rawplus_protdev %>% dplyr::filter(importnt == "Y"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test23_5 <- PD_Assess_Binary(
    dfInput = dfInput,
    strMethod = "Identity",
    vThreshold = c(0.00001, 0.1),
    strGroup = "Study"
  )

  # double programming
  t23_5_input <- dfInput

  t23_5_transformed <- dfInput %>%
    qualification_transform_counts(
      GroupID = "StudyID",
      exposureCol = "Total"
    )

  t23_5_analyzed <- t23_5_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t23_5_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t23_5_flagged <- t23_5_analyzed %>%
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

  t23_5_summary <- t23_5_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t23_5 <- list(
    "dfTransformed" = t23_5_transformed,
    "dfAnalyzed" = t23_5_analyzed,
    "dfFlagged" = t23_5_flagged,
    "dfSummary" = t23_5_summary
  )

  # compare results
  expect_equal(test23_5$lData, t23_5)
})
