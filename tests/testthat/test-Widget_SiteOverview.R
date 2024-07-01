test_that("Widget_SiteOverview processes data correctly", {
  source(test_path("testdata", "create_simple_data.R"), local = TRUE)
  widget <- Widget_SiteOverview(dfSummary, lConfig, dfSite, dfWorkflow)
  expect_s3_class(widget, c("WidgetSiteOverview", "htmlwidget"))

  expect_named(
    fromJSON(widget$x$dfSummary),
    c("StudyID", "GroupID", "Metric")
  )

  expect_s3_class(fromJSON(widget$x$dfGroups), "data.frame")
  expect_s3_class(fromJSON(widget$x$strGroupSubset), "data.frame")
})

# test_that("Widget_SiteOverview generates unique elementId", {
#   source(test_path("testdata", "create_simple_data.R"), local = TRUE)
#   widget1 <- Widget_SiteOverview(dfSummary, lConfig, dfSite, dfWorkflow, elementId = "siteOverview")
#   widget2 <- Widget_SiteOverview(dfSummary, lConfig, dfSite, dfWorkflow, elementId = "siteOverview")
#
#   expect_true(!identical(widget1$elementId, widget2$elementId))
# })

test_that("Widget_SiteOverview creates a valid HTML widget", {
  source(test_path("testdata", "create_simple_data.R"), local = TRUE)
  widget <- Widget_SiteOverview(dfSummary, lConfig, dfSite, dfWorkflow)

  # Check if the widget is of class htmlwidget
  expect_true(inherits(widget, "htmlwidget"))

  # Check if the widget has expected dimensions
  expect_equal(widget$width, "100%")
  expect_equal(widget$height, NULL)
})

