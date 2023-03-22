test_that("Given appropriate Adverse Event data, the assessment function correctly performs an Adverse Event Assessment grouped by a custom variable using the Normal Approximation method and correctly assigns Flag variable values.", {

  dfInput <- gsm::AE_Map_Raw()

  test1_9 <- AE_Assess(dfInput,
    strMethod = "NormalApprox",
    strGroup = "CustomGroup"
  )


  # Double Programming
  t9_input <- dfInput

  t9_transformed <- dfInput %>%
    qualification_transform_counts(
      GroupID = "CustomGroupID"
    )

  t9_analyzed <- t9_transformed %>%
    qualification_analyze_normalapprox(strType = "rate")

  class(t9_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t9_flagged <- t9_analyzed %>%
    qualification_flag_normalapprox()

  t9_summary <- t9_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))


  t1_9 <- list(
    "dfTransformed" = t9_transformed,
    "dfAnalyzed" = t9_analyzed,
    "dfFlagged" = t9_flagged %>% arrange(match(Flag, c(2, -2, 1, -1, 0))),
    "dfSummary" = t9_summary
  )

  expect_equal(test1_9$lData[names(test1_9$lData) != "dfBounds"], t1_9)
})
