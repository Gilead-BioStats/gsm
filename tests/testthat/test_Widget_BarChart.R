test_that("Widget_BarChart handles dfSummary correctly", {
  widget <- Widget_BarChart(sampleResults,
                            sampleMetrics %>% as.list())

  expect_true(inherits(widget, "htmlwidget"))
  expect_true("Widget_BarChart" %in% class(widget))

  widget_data <- widget$x$dfResults
  dfResults_json <- jsonlite::toJSON(sampleResults %>%
                                       dplyr::mutate(across(everything(), as.character))
  )

  expect_equal(widget_data, dfResults_json)
})

test_that("Widget_BarChart processes vThreshold correctly", {
  vThreshold <- c(1, 2, 3)

  widget <- Widget_BarChart(sampleResults,
                            sampleMetrics %>% as.list(),
                            vThreshold = vThreshold)

  vThreshold_json <- jsonlite::toJSON(vThreshold, na = "string")
  expect_equal(widget$x$vThreshold, vThreshold_json)
})

test_that("Widget_BarChart processes dfGRoups correctly", {
  widget <- Widget_BarChart(dfResults = sampleResults,
                            lMetric = sampleMetrics %>% as.list(),
                            dfGroups = sampleGroups)

  sampleGroups_json <- jsonlite::toJSON(sampleGroups, na = "string")
  expect_equal(widget$x$dfGroups, sampleGroups_json)
})
