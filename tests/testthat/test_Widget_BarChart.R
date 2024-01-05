source(testthat::test_path("testdata/data.R"))

ae <- AE_Map_Raw(
  dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ)
)

ae_transformed <- Transform_Rate(
  dfInput = ae,
  strGroupCol = "SiteID",
  strNumeratorCol = "Count",
  strDenominatorCol = "Exposure"
)

ae_analyzed <- Analyze_NormalApprox(
  dfTransformed = ae_transformed,
  strType = "rate"
)

ae_bounds <- Analyze_NormalApprox_PredictBounds(
  dfTransformed = ae_transformed,
  vThreshold = c(-3, -2, 2, 3),
  strType = "rate"
)

ae_flagged <- Flag_NormalApprox(
  dfAnalyzed = ae_analyzed,
  vThreshold = c(-3, -2, 2, 3)
)

ae_summary <- Summarize(
  dfFlagged = ae_flagged
)

lLabels <- list(
  workflowid = "",
  group = "Site",
  abbreviation = "AE",
  metric = "Adverse Event Rate",
  numerator = "Adverse Events",
  denominator = "Days on Study",
  model = "Normal Approximation",
  score = "Adjusted Z-Score"
)

chart <- Widget_BarChart(
  dfSummary = ae_summary,
  lLabels = lLabels,
  strYAxisType = "metric",
  elementId = "unit_test"
)

test_that("chart is created", {
  expect_true(all(c("Widget_BarChart", "htmlwidget") %in% class(chart)))
  expect_equal(substr(chart$elementId, 1, 9), "unit_test")
})

test_that("chart structure has not changed", {
  expect_snapshot(names(chart))
})
