# dfSummary <- data.frame(
#   MetricID = rep("M1", 5),
#   snapshot_date = as.Date(c("2024-01-01", "2024-01-01", "2024-01-02", "2024-01-02", "2024-01-02")),
#   group = rep("Group A", 5),
#   Metric = 1:5,
#   Score = 6:10
# )
#
# dfBounds <- data.frame(
#   MetricID = "M1",
#   Threshold = 0,
#   LowBound = -1,
#   HighBound = 1
# )
#
# dfMetrics <- data.frame(
#   MetricID = "M1",
#   group = "Group A",
#   abbreviation = "Metric A",
#   thresholds = c(-1, 0, 1)
# )
#
# dfParams <- data.frame(
#   workflowid = rep("qtl0004", 5),
#   param = "strGroup",
#   default_s = "Group A"
# )
#
# dfSite <- data.frame(
#   siteid = "Site A",
#   sitename = "Site A Name"
# )
#
# # Start testing
# test_that("Visualize_Metric processes data correctly", {
#   charts <- Visualize_Metric(dfSummary, dfBounds, dfSite, dfMetrics, dfParams, strMetricID = "M1")
#
#   # Test if the function returns a list of charts
#   expect_true(is.list(charts))
#
#   # Test if the list contains expected chart names
#   expect_true("scatterJS" %in% names(charts))
#   expect_true("scatter" %in% names(charts))
#   expect_true("barMetricJS" %in% names(charts))
#   expect_true("barScoreJS" %in% names(charts))
#   expect_true("barMetric" %in% names(charts))
#   expect_true("barScore" %in% names(charts))
#   expect_true("timeSeriesContinuousScoreJS" %in% names(charts))
#   expect_true("timeSeriesContinuousMetricJS" %in% names(charts))
#   expect_true("timeSeriesContinuousNumeratorJS" %in% names(charts))
# })
#
# test_that("Visualize_Metric handles missing MetricID", {
#   charts <- Visualize_Metric(dfSummary, dfBounds, dfSite, dfMetrics, dfParams, strMetricID = "M2")
#
#   # Test if the function returns NULL when MetricID is not found
#   expect_null(charts)
# })
#
# test_that("Visualize_Metric handles multiple snapshots", {
#   # Add another snapshot to the data frame
#   dfSummary <- bind_rows(dfSummary, mutate(dfSummary, snapshot_date = as.Date("2024-01-03")))
#
#   charts <- Visualize_Metric(dfSummary, dfBounds, dfSite, dfMetrics, dfParams, strMetricID = "M1")
#
#   # Test if time series charts are generated when there are multiple snapshots
#   expect_true("timeSeriesContinuousScoreJS" %in% names(charts))
#   expect_true("timeSeriesContinuousMetricJS" %in% names(charts))
#   expect_true("timeSeriesContinuousNumeratorJS" %in% names(charts))
# })

