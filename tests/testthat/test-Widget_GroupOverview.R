test_that("Widget_GroupOverview creates a valid HTML widget", {
  widget <- Widget_GroupOverview(sampleResults, sampleMetrics, sampleGroups, strGroupLevel = "Site")
  expect_s3_class(widget, c("WidgetGroupOverview", "htmlwidget"))
})

test_that("Widget_GroupOverview returns expected data", {
  widget <- Widget_GroupOverview(sampleResults, sampleMetrics, sampleGroups, strGroupLevel = "Site")

  expect_named(
    fromJSON(widget$x$dfResults),
    c('GroupID', 'GroupLevel', 'Numerator', 'Denominator', 'Metric', 'Score',
      'Flag', 'MetricID', 'StudyID', 'SnapshotDate')
  )

  expect_s3_class(fromJSON(widget$x$dfGroups), "data.frame")
  expect_s3_class(fromJSON(widget$x$strGroupSubset), "character")
})

test_that("Widget_GroupOverview returns correct class", {
  widgetOutput <- Widget_GroupOverviewOutput("test")
  expect_s3_class(widgetOutput, c("shiny.tag.list", "list"))
})

test_that("Widget_GroupOverview uses correct Group or errors out when strGroupLevel is NULL", {
  widget <- Widget_GroupOverview(sampleResults, sampleMetrics, sampleGroups)
  sampleGroupLevel <- sampleMetrics$GroupLevel %>%
    unique() %>%
    jsonlite::toJSON(na = "string", auto_unbox = T)
  expect_equal(widget$x$strGroupLevel, sampleGroupLevel)
})
