test_that("Given an appropriate subset of Labs data, the assessment function correctly performs a Labs Assessment grouped by the Study variable using the Identity method and correctly assigns Flag variable values.", {
  # gsm analysis
  dfInput <- gsm::LB_Map_Raw(dfs = list(
    dfSUBJ = clindata::rawplus_dm  %>% filter(!siteid %in% c("5", "29", "58")),
    dfLB = clindata::rawplus_lb))

  test6_5 <- LB_Assess(
    dfInput = dfInput,
    strMethod = "Identity",
    strGroup = "Study"
  )

  # Double Programming
  t6_5_input <- dfInput

  t6_5_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total",
      GroupID = "StudyID"
    )

  t6_5_analyzed <- t6_5_transformed %>%
    mutate(
      Score = Metric
    ) %>%
    arrange(Score)

  class(t6_5_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_5_flagged <- t6_5_analyzed %>%
    qualification_flag_identity(threshold = c(3.491, 5.172))

  t6_5_summary <- t6_5_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t6_5 <- list(
    "dfTransformed" = t6_5_transformed,
    "dfAnalyzed" = t6_5_analyzed,
    "dfFlagged" = t6_5_flagged,
    "dfSummary" = t6_5_summary
  )

  # compare results
  expect_equal(test6_5$lData, t6_5)
})
