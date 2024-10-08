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

test_that("Widget_TimeSeries assertions works", {
  reportingResults_modified <- as.list(reportingResults)
  reportingGroups_modified <- as.list(reportingGroups)
  expect_error(
    Widget_TimeSeries(
      reportingResults_modified,
      reportingMetrics %>% as.list()
    ),
    "dfResults is not a data.frame"
  )
  expect_error(
    Widget_TimeSeries(reportingResults, reportingMetrics),
    "lMetric must be a list, but not a data.frame"
  )
  expect_error(
    Widget_TimeSeries(
      reportingResults,
      reportingMetrics %>% as.list(),
      reportingGroups_modified
    ),
    "dfGroups is not a data.frame"
  )
  expect_error(
    Widget_TimeSeries(
      reportingResults,
      reportingMetrics %>% as.list(),
      strOutcome = 1
    ),
    "strOutcome is not a character"
  )
  expect_error(
    Widget_TimeSeries(
      reportingResults,
      reportingMetrics %>% as.list(),
      bAddGroupSelect = NULL
    ),
    "bAddGroupSelect is not a logical"
  )
  expect_error(
    Widget_TimeSeries(
      reportingResults,
      reportingMetrics %>% as.list(),
      strShinyGroupSelectID = 1
    ),
    "strShinyGroupSelectID is not a character"
  )
  expect_error(
    Widget_TimeSeries(
      reportingResults,
      reportingMetrics %>% as.list(),
      bDebug = NULL
    ),
    "bDebug is not a logical"
  )
})
