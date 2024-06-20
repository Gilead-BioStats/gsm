test_that("Given an appropriate subset of Adverse Event data, the assessment function correctly performs an Adverse Event Assessment grouped by the Site variable using the Poisson method and correctly assigns Flag variable values when given a custom threshold.", {
  # gsm analysis
  # dfInput <- gsm::AE_Map_Raw(dfs = list(
  #   dfAE = clindata::rawplus_ae %>% filter(aeser_std_nsv == "Y"),
  #   dfSUBJ = clindata::rawplus_dm
  # ))
  #
  # test1_1 <- AE_Assess(
  #   dfInput = dfInput,
  #   strMethod = "Poisson",
  #   vThreshold = c(-3, -1, 1, 3)
  # )
  #
  # # Double Programming
  # t1_input <- dfInput
  #
  # t1_transformed <- dfInput %>%
  #   qualification_transform_counts()
  #
  # t1_analyzed <- t1_transformed %>%
  #   qualification_analyze_poisson()
  #
  # class(t1_analyzed) <- c("tbl_df", "tbl", "data.frame")
  #
  # t1_flagged <- t1_analyzed %>%
  #   qualification_flag_poisson(threshold = c(-3, -1, 1, 3))
  #
  # t1_summary <- t1_flagged %>%
  #   select(GroupID, Numerator, Denominator, Metric, Score, Flag) %>%
  #   arrange(desc(abs(Metric))) %>%
  #   arrange(match(Flag, c(2, -2, 1, -1, 0)))
  #
  # t1_1 <- list(
  #   "dfTransformed" = t1_transformed,
  #   "dfAnalyzed" = t1_analyzed,
  #   "dfFlagged" = t1_flagged,
  #   "dfSummary" = t1_summary
  # )
  #
  # # remove metadata that is not part of qualification
  # test1_1$lData$dfConfig <- NULL
  #
  # # compare results
  # # remove bounds dataframe for now
  # expect_equal(test1_1$lData[names(test1_1$lData) != "dfBounds"], t1_1)
})
