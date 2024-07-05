test_that("Widget_ScatterPlot handles dfSummary correctly", {
  dfSummary <- data.frame(GroupID = 1:3, Metric = 4:6, stringsAsFactors = FALSE)
  lLabels <- list(Group = "TestGroup")

  widget <- Widget_ScatterPlot(dfSummary, lLabels)

  expect_true(inherits(widget, "htmlwidget"))
  expect_true("Widget_ScatterPlot" %in% class(widget))

  widget_data <- widget$x$dfSummary
  dfSummary_json <- jsonlite::toJSON(dfSummary, na = "string")

  expect_equal(widget_data, dfSummary_json)
})

test_that("Widget_ScatterPlot processes dfBounds correctly", {
  dfSummary <- data.frame(GroupID = 1:3, Metric = 4:6, stringsAsFactors = FALSE)
  lLabels <- list(Group = "TestGroup")
  dfBounds <- data.frame(BoundID = c(1, 2, 3), Threshold = c(10, 20, 30), stringsAsFactors = FALSE)

  widget <- Widget_ScatterPlot(dfSummary, lLabels, dfBounds = dfBounds)

  dfBounds_json <- jsonlite::toJSON(dfBounds)
  expect_equal(widget$x$dfBounds, dfBounds_json)
})

test_that("Widget_ScatterPlot processes dfSite correctly", {
  dfSummary <- data.frame(GroupID = 1:3, Metric = 4:6, stringsAsFactors = FALSE)
  lLabels <- list(Group = "TestGroup")
  dfSite <- data.frame(SiteID = c(1, 2, 3), stringsAsFactors = FALSE)

  widget <- Widget_ScatterPlot(dfSummary, lLabels, dfGroups = dfSite)

  dfSite_json <- jsonlite::toJSON(dfSite, na = "string")
  expect_equal(widget$x$dfGroups, dfSite_json)
})



