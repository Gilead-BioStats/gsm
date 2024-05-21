# # Create dummy data for testing
# dfSummary <- data.frame(
#   MetricID = c("metric1", "metric1"),
#   snapshot_date = as.Date(c("2024-01-01", "2024-01-02")),
#   value = c(100, 200)
# )
#
# dfBounds <- data.frame(
#   MetricID = c("metric1"),
#   lower_bound = c(50),
#   upper_bound = c(150)
# )
#
# dfMetrics <- data.frame(
#   MetricID = c("metric1"),
#   abbreviation = c("M1"),
#   group = c("Group1"),
#   thresholds = I(list(c(80, 120)))
# )
#
# dfParams <- data.frame(
#   param1 = c(1, 2),
#   param2 = c(3, 4)
# )
#
# test_that("Sets snapshot_date to today if missing", {
#   dfSummary_no_date <- dfSummary %>% select(-snapshot_date)
#   result <- Visualize_Metric(dfSummary_no_date)
#   expect_equal(unique(result$scatterJS$dfSummary$snapshot_date), Sys.Date())
# })
#
# test_that("Uses most recent snapshot date if strSnapshotDate is missing", {
#   result <- Visualize_Metric(dfSummary)
#   expect_equal(result$scatterJS$dfSummary$snapshot_date, as.Date("2024-01-02"))
# })
#
# test_that("Returns NULL and logs error if MetricID not found", {
#   expect_output({
#     result <- Visualize_Metric(dfSummary, strMetricID = "nonexistent_metric")
#   }, "MetricID not found in dfSummary. No charts will be generated.")
#   expect_null(result)
# })
#
# test_that("Returns NULL and logs error if multiple MetricIDs found", {
#   dfSummary_multiple_metrics <- rbind(dfSummary, data.frame(MetricID = "metric2", snapshot_date = as.Date("2024-01-01"), value = 300))
#   expect_output({
#     result <- Visualize_Metric(dfSummary_multiple_metrics)
#   }, "Multiple MetricIDs found in dfSummary, dfBounds or dfMetrics. Specify `MetricID` to subset. No charts will be generated.")
#   expect_null(result)
# })
#
# test_that("Generates charts correctly for valid data", {
#   result <- Visualize_Metric(dfSummary, dfBounds, NULL, dfMetrics, dfParams)
#   expect_true("scatterJS" %in% names(result))
#   expect_true("barMetricJS" %in% names(result))
#   expect_true("barScoreJS" %in% names(result))
#   expect_true("barMetric" %in% names(result))
#   expect_true("barScore" %in% names(result))
#
#   expect_equal(result$scatterJS$dfSummary$snapshot_date, as.Date("2024-01-02"))
#   expect_equal(result$scatterJS$lLabels$abbreviation, "M1")
# })
