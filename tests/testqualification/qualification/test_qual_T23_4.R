test_that("PD assessment can return a correctly assessed data frame for the identity test grouped by the site variable when given subset input data from clindata and the results should be flagged correctly using a custom threshold.", {
  # gsm analysis
  dfInput <- gsm::PD_Map_Raw_Binary(dfs = list(
    dfPD = clindata::rawplus_protdev %>% dplyr::filter(importnt == "Y"),
    dfSUBJ = clindata::rawplus_dm
  ))

  test23_4 <- PD_Assess_Binary(
    dfInput = dfInput,
    strMethod = "Identity"
  )

  # double programming
  t23_4_input <- dfInput

  t23_4_transformed <- dfInput %>%
    qualification_transform_counts(exposureCol = "Total")

  t23_4_analyzed <- t23_4_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t23_4_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t23_4_flagged <- t23_4_analyzed %>%
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

  t23_4_summary <- t23_4_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t23_4 <- list(
    "dfTransformed" = t23_4_transformed,
    "dfAnalyzed" = t23_4_analyzed,
    "dfFlagged" = t23_4_flagged,
    "dfSummary" = t23_4_summary
  )

  # compare results
  expect_equal(test23_4$lData, t23_4)
})
