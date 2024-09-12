test_that("Widget_BarChart handles dfResults correctly", {
  widget <- Widget_BarChart(
    reportingResults[1:1000,],
    reportingMetrics %>% as.list()
  )

  expect_true(inherits(widget, "htmlwidget"))
  expect_true("Widget_BarChart" %in% class(widget))

  widget_data <- widget$x$dfResults
  dfResults <- reportingResults[1:1000,] %>%
    dplyr::mutate(
      Metric = round(Metric, 4),
      Score = round(Score, 4),
      SnapshotDate = as.character(SnapshotDate)
    )

  expect_equal(jsonlite::fromJSON(widget_data), dfResults)
})

test_that("Widget_BarChart processes vThreshold correctly", {
  vThreshold <- c(1, 2, 3)

  widget <- Widget_BarChart(reportingResults,
    reportingMetrics %>% as.list(),
    vThreshold = vThreshold
  )

  vThreshold_json <- jsonlite::toJSON(vThreshold, na = "string")
  expect_equal(widget$x$vThreshold, vThreshold_json)
})

test_that("Widget_BarChart processes dfGRoups correctly", {
  widget <- Widget_BarChart(
    dfResults = reportingResults,
    lMetric = reportingMetrics %>% as.list(),
    dfGroups = reportingGroups
  )

  reportingGroups_json <- jsonlite::toJSON(reportingGroups, na = "string")
  expect_equal(widget$x$dfGroups, reportingGroups_json)
})

test_that("Widget_BarChart assertions works", {
  reportingResults_modified <- as.list(reportingResults)
  reportingGroups_modified <- as.list(reportingGroups)
  expect_error(
    Widget_BarChart(
      reportingResults_modified,
      reportingMetrics %>% as.list()
    ),
    "dfResults is not a data.frame"
  )
  expect_error(
    Widget_BarChart(reportingResults, reportingMetrics),
    "lMetric must be a list, but not a data.frame"
  )
  expect_error(
    Widget_BarChart(
      reportingResults,
      reportingMetrics %>% as.list(),
      reportingGroups_modified
    ),
    "dfGroups is not a data.frame"
  )
  expect_error(
    Widget_BarChart(
      reportingResults,
      reportingMetrics %>% as.list(),
      strOutcome = 1
    ),
    "strOutcome is not a character"
  )
  expect_error(
    Widget_BarChart(
      reportingResults,
      reportingMetrics %>% as.list(),
      bAddGroupSelect = NULL
    ),
    "bAddGroupSelect is not a logical"
  )
  expect_error(
    Widget_BarChart(
      reportingResults,
      reportingMetrics %>% as.list(),
      strShinyGroupSelectID = 1
    ),
    "strShinyGroupSelectID is not a character"
  )
  expect_error(
    Widget_BarChart(
      reportingResults,
      reportingMetrics %>% as.list(),
      bDebug = NULL
    ),
    "bDebug is not a logical"
  )
})

