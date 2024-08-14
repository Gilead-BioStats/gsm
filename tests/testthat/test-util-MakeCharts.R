test_that("MakeCharts makes charts", {
  # Mock Visualize_Metric() since that has its own tests.
  local_mocked_bindings(
    Visualize_Metric = function(
      dfResults,
      dfBounds,
      dfGroups,
      dfMetrics,
      strMetricID,
      ...
    ) {
      list(
        dfResults = nrow(dfResults),
        dfBounds = nrow(dfBounds),
        dfGroups = nrow(dfGroups),
        dfMetrics = nrow(dfMetrics),
        strMetricID = strMetricID,
        bDebug = FALSE
      )
    }
  )
  charts <- MakeCharts(
    dfResults = reportingResults,
    dfBounds = reportingBounds,
    dfGroups = reportingGroups,
    dfMetrics = reportingMetrics
  )
  expect_snapshot({
    str(charts, max.level = 2)
  })
})
