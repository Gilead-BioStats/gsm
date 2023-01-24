test_that("Disposition assessment can return a correctly assessed data frame for the normal approximation test grouped by the site variable when given subset input data from clindata and the results should be flagged correctly", {
  # gsm analysis
  dfInput <- gsm::Disp_Map_Raw(dfs = list(
    dfSUBJ = clindata::rawplus_dm,
    dfSTUDCOMP = clindata::rawplus_studcomp %>% filter(compreas_std_nsv == "ID"),
    dfSDRGCOMP = clindata::rawplus_sdrgcomp %>% filter(datapagename ==
                                                         "Blinded Study Drug Completion")
  ))

  test5_6 <- Disp_Assess(
    dfInput = dfInput,
    strMethod = "NormalApprox"
  )

  # Double Programming
  t5_6_input <- dfInput

  t5_6_transformed <- dfInput %>%
    qualification_transform_counts(
      exposureCol = "Total"
    )

  t5_6_analyzed <- t5_6_transformed %>%
    qualification_analyze_normalapprox(strType = "binary")

  class(t5_6_analyzed) <- c("tbl_df", "tbl", "data.frame")

  t5_6_flagged <- t5_6_analyzed %>%
    qualification_flag_normalapprox()

  t5_6_summary <- t5_6_flagged %>%
    select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
    arrange(desc(abs(Metric))) %>%
    arrange(match(Flag, c(2, -2, 1, -1, 0)))

  t5_6 <- list(
    "dfTransformed" = t5_6_transformed,
    "dfAnalyzed" = t5_6_analyzed,
    "dfFlagged" = t5_6_flagged,
    "dfSummary" = t5_6_summary
  )

  # compare results
  expect_equal(test5_6$lData[!names(test5_6$lData) == "dfBounds"], t5_6)
})
