test_that("Widget_BarChart handles dfSummary correctly", {
  dfSummary <- data.frame(GroupID = as.character(1:3), Metric = as.character(4:6), stringsAsFactors = FALSE)
  lLabels <- list(Group = "TestGroup")

  widget <- Widget_BarChart(dfSummary,
                            lLabels)

  expect_true(inherits(widget, "htmlwidget"))
  expect_true("Widget_BarChart" %in% class(widget))

  widget_data <- widget$x$dfSummary
  dfSummary_json <- jsonlite::toJSON(dfSummary %>%
                                       dplyr::mutate(across(everything(), as.character))
  )

  expect_equal(widget_data, dfSummary_json)
})

test_that("Widget_BarChart processes dfThreshold correctly", {
  dfSummary <- data.frame(GroupID = as.character(1:3), Metric = as.character(4:6), stringsAsFactors = FALSE)
  lLabels <- list(Group = "TestGroup")
  vThreshold <- c(1, 2, 3)

  widget <- Widget_BarChart(dfSummary, lLabels, vThreshold = vThreshold)

  vThreshold_json <- jsonlite::toJSON(vThreshold, na = "string")
  expect_equal(widget$x$vThreshold, vThreshold_json)
})

test_that("Widget_BarChart processes dfSite correctly", {
  dfSummary <- data.frame(GroupID = as.character(1:3), Metric = as.character(4:6), stringsAsFactors = FALSE)
  lLabels <- list(Group = "TestGroup")
  dfSite <- data.frame(SiteID = c(1, 2, 3), stringsAsFactors = FALSE)

  widget <- Widget_BarChart(dfSummary, lLabels, dfGroups = dfSite)

  dfSite_json <- jsonlite::toJSON(dfSite, na = "string")
  expect_equal(widget$x$dfGroups, dfSite_json)
})
