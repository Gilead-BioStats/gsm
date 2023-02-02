test_that("PD assessment can return a correctly assessed data frame for the identity test grouped by the site variable when given subset input data from clindata and the results should be flagged correctly using a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Binary(dfs = list(
    dfPD = clindata::rawplus_protdev %>% filter(importnt == "Y"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test27_4 <- PD_Assess_Binary(
    dfInput = dfInput,
    strMethod = "Identity"
  )

  # double programming
  t27_4_input <- dfInput

  t27_4_transformed <- dfInput %>%
    qualification_transform_counts(exposureCol = "Total")

  t27_4_analyzed <- t27_4_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t27_4_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t27_4_flagged <- t27_4_analyzed %>%
    mutate(
      Flag = case_when(
        Score < 0.000895 ~ -1,
        Score > 0.003059 ~ 1,
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

  t27_4_summary <- t27_4_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t27_4 <- list(
    "dfTransformed" = t27_4_transformed,
    "dfAnalyzed" = t27_4_analyzed,
    "dfFlagged" = t27_4_flagged,
    "dfSummary" = t27_4_summary
  )

  # compare results
  expect_equal(test27_4$lData, t27_4)
})
