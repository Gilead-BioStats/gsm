test_that("Widget_SiteOverview creates a valid HTML widget", {
  source(test_path("testdata", "create_simple_data.R"), local = TRUE)
  widget <- Widget_SiteOverview(dfSummary, lConfig, dfSite, dfWorkflow)
  expect_s3_class(widget, c("WidgetSiteOverview", "htmlwidget"))
})

test_that("Widget_SiteOverview returns expected data", {
  source(test_path("testdata", "create_simple_data.R"), local = TRUE)
  widget <- Widget_SiteOverview(dfSummary, lConfig, dfSite, dfWorkflow)

  expect_named(
    fromJSON(widget$x$dfSummary),
    c("StudyID", "GroupID", "Metric")
  )

  expect_s3_class(fromJSON(widget$x$dfGroups), "data.frame")
  expect_s3_class(fromJSON(widget$x$strGroupSubset), "data.frame")
})
