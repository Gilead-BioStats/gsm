test_that("Widget_ScatterPlot handles dfSummary correctly", {
  widget <- Widget_ScatterPlot(sampleResults,
                               sampleMetrics %>% as.list())

  expect_true(inherits(widget, "htmlwidget"))
  expect_true("Widget_ScatterPlot" %in% class(widget))

  widget_data <- widget$x$dfResults
  dfSummary_json <- jsonlite::toJSON(sampleResults, na = "string")

  expect_equal(widget_data, dfSummary_json)
})

test_that("Widget_ScatterPlot processes dfBounds correctly", {
  widget <- Widget_ScatterPlot(sampleResults,
                               sampleMetrics %>% as.list(),
                               dfBounds = sampleBounds)

  dfBounds_json <- jsonlite::toJSON(sampleBounds)
  expect_equal(widget$x$dfBounds, dfBounds_json)
})

test_that("Widget_ScatterPlot processes dfGroups correctly", {
  widget <- Widget_ScatterPlot(dfResults = sampleResults,
                               lMetric = sampleMetrics %>% as.list(),
                               dfGroups = sampleGroups)

  dfGroups_json <- jsonlite::toJSON(sampleGroups, na = "string")
  expect_equal(widget$x$dfGroups, dfGroups_json)
})



