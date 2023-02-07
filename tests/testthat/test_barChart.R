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

dfConfig <- MakeDfConfig(
  strMethod = "NormalApprox",
  strGroup = "Site",
  strAbbreviation = "AE",
  strMetric = "Adverse Event Rate",
  strNumerator = "Adverse Events",
  strDenominator = "Days on Treatment",
  vThreshold = c(-3, -2, 2, 3)
)

chart <- barChart(
  results = ae_summary,
  workflow = dfConfig,
  yaxis = "metric",
  elementId = "unit_test"
)

test_that("chart is created", {
  expect_true(all(c("barChart", "htmlwidget") %in% class(chart)))
  expect_equal(substr(chart$elementId, 1, 9), "unit_test")
  expect_equal(
    nrow(chart$x$results),
    nrow(ae_summary)
  )
})

test_that("chart structure has not changed", {
  expect_snapshot(chart)
})
