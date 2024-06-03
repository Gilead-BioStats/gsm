qtl <- "qtl0004"

dfSummary <- data.frame(
  workflowid = rep(qtl, 3),
  studyid = c("AA-AA-000-0000", "BB-BB-111-1111", "CC-CC-222-2222"),
  siteid = c("Site A", "Site B", "Site C"),
  numerator_value = c(10, 20, 30),
  denominator_value = c(100, 200, 300),
  metric_value = c(0.1, 0.2, 0.3),
  score = c(5, 10, 15),
  flag_value = c(0, 1, -1),
  gsm_analysis_date = rep("2023-12-19", 3),
  snapshot_date = rep("2023-12-19", 3)
)

lLabels <- list(
  title = "Time Series QTL Widget",
  group = "GroupID"
)

dfParams <- data.frame(
  workflowid = rep(qtl, 3),
  studyid = rep("AA-AA-000-0000", 3),
  param = "strGroup",
  default_s = c("Group A", "Group B", "Group C"),
  index = rep("test", 3),
  gsm_analysis_date = rep("2023-12-19", 3),
  snapshot_date = rep("2023-12-19", 3)
)

dfAnalysis <- data.frame(
  workflowid = rep(qtl, 3),
  studyid = rep("AA-AA-000-0000", 3),
  param = c("LowCI", "HighCI", "MeanCI"),
  value = c(0, 10, 5),
  index = rep("test", 3),
  gsm_analysis_date = rep("2023-12-19", 3),
  snapshot_date = rep("2023-12-19", 3)
)

selectedGroupIDs <- c("Group A", "Group B")

# Start testing
test_that("Widget_TimeSeriesQTL processes data correctly", {
  widget <- Widget_TimeSeriesQTL(qtl, dfSummary, lLabels, dfParams, dfAnalysis, selectedGroupIDs)

  # Test that dfSummary, dfParams, and dfAnalysis are converted to JSON
  expect_true(class(fromJSON(widget$x$results)) == "data.frame")
  expect_true(class(fromJSON(widget$x$workflow)) == "list")
  expect_true(class(fromJSON(widget$x$parameters)) == "data.frame")
  expect_true(class(fromJSON(widget$x$analysis)) == "data.frame")
})

test_that("Widget_TimeSeriesQTL creates a valid HTML widget", {
  widget <- Widget_TimeSeriesQTL(qtl, dfSummary, lLabels, dfParams, dfAnalysis, selectedGroupIDs)

  # Check if the widget is of class htmlwidget
  expect_true(inherits(widget, "htmlwidget"))

  # Check if the widget has expected dimensions
  expect_equal(widget$width, NULL)
  expect_equal(widget$height, NULL)
})

