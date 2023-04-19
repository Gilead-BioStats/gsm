test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

# test <- Make_Snapshot(bReturnStudyObject = TRUE)
# test2 <- MakeTrendData(test, here::here("snapshots"))
#
# Widget_TimeSeries(
#   'kri0001',
#   test2$lStudyAssessResults$longitudinal$results_summary,
#   test2$lStudyAssessResults$longitudinal$meta_workflow,
#   test2$lStudyAssessResults$longitudinal$params
# )
#
# Widget_TimeSeriesQTL(
#   'qtl0004',
#   test2$lStudyAssessResults$longitudinal$results_summary,
#   test2$lStudyAssessResults$longitudinal$meta_workflow,
#   test2$lStudyAssessResults$longitudinal$params,
#   test2$lStudyAssessResults$longitudinal$results_analysis
# )
