test_that("Widget_GroupOverview creates a valid HTML widget", {
  widget <- Widget_GroupOverview(reportingResults, reportingMetrics, reportingGroups, strGroupLevel = "Site")
  expect_s3_class(widget, c("WidgetGroupOverview", "htmlwidget"))
})

test_that("Widget_GroupOverview returns expected data", {
  widget <- Widget_GroupOverview(reportingResults, reportingMetrics, reportingGroups, strGroupLevel = "Site")

  expect_named(
    fromJSON(widget$x$dfResults),
    c(
      "GroupID", "GroupLevel", "Numerator", "Denominator", "Metric", "Score",
      "Flag", "MetricID", "SnapshotDate", "StudyID"
    )
  )

  expect_s3_class(fromJSON(widget$x$dfGroups), "data.frame")
  expect_equal(fromJSON(widget$x$strGroupSubset), "red")
})

test_that("Widget_GroupOverview returns correct class", {
  widgetOutput <- Widget_GroupOverviewOutput("test")
  expect_s3_class(widgetOutput, c("shiny.tag.list", "list"))
})

test_that("Widget_GroupOverview uses correct Group or errors out when strGroupLevel is NULL", {
  widget <- Widget_GroupOverview(reportingResults, reportingMetrics, reportingGroups)
  sampleGroupLevel <- reportingMetrics$GroupLevel %>%
    unique() %>%
    jsonlite::toJSON(na = "string", auto_unbox = T)
  expect_equal(widget$x$strGroupLevel, sampleGroupLevel)
})
