test <- Make_Snapshot()
test2 <- MakeTrendData(test, here::here("snapshots"), FALSE)

studyobj <- Study_Assess()


timeSeriesContinuous(
  "kri0001",
  test2$longitudinal$results_summary,
  test2$longitudinal$meta_workflow,
  test2$longitudinal$params
)

test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})
