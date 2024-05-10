skip()
# Install and load the `testthat` package ----------------------------
source(testthat::test_path("testdata/data.R"))

# Create sample data -------------------------------------------------
snap1 <- Make_Snapshot(lData = lData, strAnalysisDate = "2021-01-01")
snap2 <- Make_Snapshot(lData = lData, strAnalysisDate = "2022-01-01", lPrevSnapshot = snap1)
snap3 <- Make_Snapshot(lData = lData, strAnalysisDate = "2023-01-01", lPrevSnapshot = snap2)

# Tests --------------------------------------------------------------
test_that("Widget_TimeSeries() outputs data properly", {
  plot <- Widget_TimeSeries(
    dfSummary = snap3$lStackedSnapshots$rpt_site_kri_details,
    lLabels = snap3$lStackedSnapshots$rpt_kri_details,
    dfParams = snap3$lStackedSnapshots$rpt_kri_threshold_param
  )

  expect_equal(
    names(plot), c(
      "x", "width", "height", "sizingPolicy", "dependencies",
      "elementId", "preRenderHook", "jsHooks", "prepend"
    )
  )

  expect_snapshot(plot)

  # dfSummary ---------------------------------------------------------------------------
  dfSummary_names <- c(
    "studyid", "groupid", "numerator", "denominator", "metric",
    "score", "flag", "gsm_analysis_date", "snapshot_date"
  )

  expect_true(
    all(map_vec(dfSummary_names, ~ str_detect(as.character(plot$x$dfSummary), pattern = .)))
  )

  # lLabels -----------------------------------------------------------------------------
  lLabel_names <- c(
    "workflowid", "group", "abbreviation", "metric", "numerator", "denominator",
    "outcome", "model", "score", "data_inputs", "data_filters", "gsm_analysis_date", "y"
  )

  expect_equal(lLabel_names, names(plot$x$lLabels))

  # dfParams ----------------------------------------------------------------------------
  dfParams_names <- c(
    "workflowid", "param", "index", "gsm_analysis_date",
    "snapshot_date", "studyid", "value"
  )

  expect_true(
    all(map_vec(dfParams_names, ~ str_detect(as.character(plot$x$dfParams), pattern = .)))
  )
})
