test_that("Widget_FlagOverTime creates a valid HTML widget", {
  widget <- Widget_FlagOverTime(
    reportingResults,
    reportingMetrics,
    strGroupLevel = "Site"
  )
  expect_s3_class(widget, c("WidgetGroupOverview", "htmlwidget"))
  expect_true(
    stringr::str_detect(
      widget$x$html,
      "<table class=\"gt_table\""
    )
  )
})
