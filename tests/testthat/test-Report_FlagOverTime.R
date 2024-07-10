test_that("Report_FlagOverTime returns the expected object", {
  dfSummary <- data.frame(
    GroupID = c(100, 100, 100, 200, 200, 200),
    GroupLevel = rep("Site", 6),
    MetricID = rep("kri1", 6),
    snapshot_date = rep(c("2021-01-01", "2021-02-01", "2021-03-01"), 2),
    Flag = c(-2, -1, 0, NA, 1, -1)
  )
  dfMetrics <- data.frame(
    MetricID = c('kri1', 'kri2'),
    abbreviation = c("AE", "SAE")
  )
  x <- Report_FlagOverTime(dfSummary, dfMetrics)
  expect_s3_class(x, "gt_tbl")
  expect_snapshot(unclass(x))
})
