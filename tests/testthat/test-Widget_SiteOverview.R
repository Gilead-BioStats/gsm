dfSummary <- data.frame(
  StudyID = c(1, 2, 3),
  GroupID = c("A", "B", "C"),
  Metric = c(10, 20, 30)
)

lConfig <- list(
  title = "Site Overview Widget"
)

dfSite <- data.frame(
  SiteID = c(1, 2, 3),
  SiteName = c("Site A", "Site B", "Site C")
)

dfWorkflow <- data.frame(
  WorkflowID = c(1, 2, 3),
  WorkflowName = c("Workflow 1", "Workflow 2", "Workflow 3")
)

# Start testing
test_that("Widget_SiteOverview processes data correctly", {
  widget <- Widget_SiteOverview(dfSummary, lConfig, dfSite, dfWorkflow)

  # Test that dfSummary is converted to lowercase
  expect_true(all(names(fromJSON(widget$x$dfSummary)) == c("StudyID", "GroupID", "Metric")))

  # Test that dfSite and dfWorkflow are converted to JSON
  expect_true(class(fromJSON(widget$x$dfSite)) == "data.frame")
  expect_true(class(fromJSON(widget$x$dfWorkflow)) == "data.frame")
})

test_that("Widget_SiteOverview generates unique elementId", {
  widget1 <- Widget_SiteOverview(dfSummary, lConfig, dfSite, dfWorkflow, elementId = "siteOverview")
  widget2 <- Widget_SiteOverview(dfSummary, lConfig, dfSite, dfWorkflow, elementId = "siteOverview")

  expect_true(!identical(widget1$elementId, widget2$elementId))
})

test_that("Widget_SiteOverview creates a valid HTML widget", {
  widget <- Widget_SiteOverview(dfSummary, lConfig, dfSite, dfWorkflow)

  # Check if the widget is of class htmlwidget
  expect_true(inherits(widget, "htmlwidget"))

  # Check if the widget has expected dimensions
  expect_equal(widget$width, NULL)
  expect_equal(widget$height, NULL)
})

