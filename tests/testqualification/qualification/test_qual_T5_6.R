test_that("Disposition assessment can return a correctly assessed data frame for the normal approximation test grouped by the site variable when given correct input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- gsm::Disp_Map_Raw()

  test6_1 <- Disp_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox"
  )

  # Double Programming
  t6_1_input <- dfInput

  t6_1_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total"
    )

  t6_1_analyzed <- t6_1_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t6_1_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t6_1_flagged <- t6_1_analyzed %>%
    qualification_flag_normalapprox()

  t6_1_summary <- t6_1_flagged %>%
    select(GroupID, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(1, -1, 0)))

  t6_1 <- list(
    "dfTransformed" = t6_1_transformed,
    "dfAnalyzed" = t6_1_analyzed,
    "dfFlagged" = t6_1_flagged,
    "dfSummary" = t6_1_summary
  )

  # compare results
  expect_equal(test6_1$lData[!names(test6_1$lData) == "dfBounds"], t6_1)
})
