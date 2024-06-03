test_that("Widget_BarChart handles dfSummary correctly", {
  dfSummary <- data.frame(GroupID = 1:3, Metric = 4:6, stringsAsFactors = FALSE)
  lLabels <- list(group = "TestGroup")

  widget <- Widget_BarChart(dfSummary, lLabels)

  expect_true(inherits(widget, "htmlwidget"))
  expect_true("Widget_BarChart" %in% class(widget))

  widget_data <- widget$x$dfSummary
  dfSummary_json <- jsonlite::toJSON(dfSummary %>%
                                       dplyr::mutate(across(everything(), as.character)) %>%
                                       dplyr::rename_with(tolower), na = "string")

  expect_equal(widget_data, dfSummary_json)
})

test_that("Widget_BarChart processes dfThreshold correctly", {
  dfSummary <- data.frame(GroupID = 1:3, Metric = 4:6, stringsAsFactors = FALSE)
  lLabels <- list(group = "TestGroup")
  dfThreshold <- data.frame(Threshold = c(1, 2, 3), stringsAsFactors = FALSE)

  widget <- Widget_BarChart(dfSummary, lLabels, dfThreshold = dfThreshold)

  dfThreshold_json <- jsonlite::toJSON(dfThreshold, na = "string")
  expect_equal(widget$x$dfThreshold, dfThreshold_json)
})

test_that("Widget_BarChart processes dfSite correctly", {
  dfSummary <- data.frame(GroupID = 1:3, Metric = 4:6, stringsAsFactors = FALSE)
  lLabels <- list(group = "TestGroup")
  dfSite <- data.frame(SiteID = c(1, 2, 3), stringsAsFactors = FALSE)

  widget <- Widget_BarChart(dfSummary, lLabels, dfSite = dfSite)

  dfSite_json <- jsonlite::toJSON(dfSite, na = "string")
  expect_equal(widget$x$dfSite, dfSite_json)
})

test_that("Widget_BarChart handles selectedGroupIDs correctly", {
  dfSummary <- data.frame(GroupID = 1:3, Metric = 4:6, stringsAsFactors = FALSE)
  lLabels <- list(group = "TestGroup")
  selectedGroupIDs <- c(1, 3)

  widget <- Widget_BarChart(dfSummary, lLabels, selectedGroupIDs = selectedGroupIDs)

  expect_equal(widget$x$selectedGroupIDs, as.character(selectedGroupIDs))
})

test_that("Widget_BarChart sets siteSelectLabelValue correctly", {
  dfSummary <- data.frame(GroupID = 1:3, Metric = 4:6, stringsAsFactors = FALSE)
  lLabels <- list(group = "TestGroup")

  widget <- Widget_BarChart(dfSummary, lLabels)

  expect_equal(widget$x$siteSelectLabelValue, "Highlighted TestGroup: ")
})

test_that("Widget_BarChart sets elementId correctly", {
  dfSummary <- data.frame(GroupID = 1:3, Metric = 4:6, stringsAsFactors = FALSE)
  lLabels <- list(group = "TestGroup")
  elementId <- "test-id"

  widget <- Widget_BarChart(dfSummary, lLabels, elementId = elementId)
  expected_elementId <- paste(elementId, as.numeric(Sys.time()) * 1000, sep = "-")

  expect_true(grepl(paste0("^", elementId, "-"), widget$elementId))
})

