test_that("Widget_TimeSeries processes dfResults correctly", {
  widget <- suppressWarnings(Widget_TimeSeries(reportingResults,
    reportingMetrics %>% as.list(),
    strOutcome = "Metric"
  ))

  dfResults_expected <- reportingResults %>%
    jsonlite::toJSON(na = "string")

  expect_equal(widget$x$dfResults, dfResults_expected)
})


test_that("Widget_TimeSeries handles dfGroups correctly", {
  widget <- Widget_TimeSeries(reportingResults,
    reportingMetrics %>% as.list(),
    dfGroups = reportingGroups,
    strOutcome = "Score"
  ) %>%
    suppressWarnings()

  dfGroups_expected <- reportingGroups %>%
    jsonlite::toJSON(na = "string")

  expect_equal(widget$x$dfGroups, dfGroups_expected)
})

test_that("Widget_TimeSeries sets vThreshold correctly", {
  vThreshold <- c(1, 2, 3)

  widget <- Widget_TimeSeries(reportingResults,
    reportingMetrics %>% as.list(),
    vThreshold = vThreshold
  )

  vThreshold_json <- jsonlite::toJSON(vThreshold, na = "string")
  expect_equal(widget$x$vThreshold, vThreshold_json)
})
