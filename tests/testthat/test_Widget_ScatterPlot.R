test_that("Widget_ScatterPlot handles dfSummary correctly", {
  dfSummary <- data.frame(GroupID = 1:3, Metric = 4:6, stringsAsFactors = FALSE)
  lLabels <- list(group = "TestGroup")

  widget <- Widget_ScatterPlot(dfSummary, lLabels)

  expect_true(inherits(widget, "htmlwidget"))
  expect_true("Widget_ScatterPlot" %in% class(widget))

  widget_data <- widget$x$dfSummary
  dfSummary_json <- jsonlite::toJSON(dfSummary %>% dplyr::rename_with(tolower), na = "string")

  expect_equal(widget_data, dfSummary_json)
})

test_that("Widget_ScatterPlot processes dfBounds correctly", {
  dfSummary <- data.frame(GroupID = 1:3, Metric = 4:6, stringsAsFactors = FALSE)
  lLabels <- list(group = "TestGroup")
  dfBounds <- data.frame(BoundID = c(1, 2, 3), Threshold = c(10, 20, 30), stringsAsFactors = FALSE)

  widget <- Widget_ScatterPlot(dfSummary, lLabels, dfBounds = dfBounds)

  dfBounds_json <- jsonlite::toJSON(dfBounds %>% dplyr::rename_with(tolower))
  expect_equal(widget$x$dfBounds, dfBounds_json)
})

test_that("Widget_ScatterPlot processes dfSite correctly", {
  dfSummary <- data.frame(GroupID = 1:3, Metric = 4:6, stringsAsFactors = FALSE)
  lLabels <- list(group = "TestGroup")
  dfSite <- data.frame(SiteID = c(1, 2, 3), stringsAsFactors = FALSE)

  widget <- Widget_ScatterPlot(dfSummary, lLabels, dfSite = dfSite)

  dfSite_json <- jsonlite::toJSON(dfSite, na = "string")
  expect_equal(widget$x$dfSite, dfSite_json)
})

test_that("Widget_ScatterPlot handles selectedGroupIDs correctly", {
  dfSummary <- data.frame(GroupID = 1:3, Metric = 4:6, stringsAsFactors = FALSE)
  lLabels <- list(group = "TestGroup")
  selectedGroupIDs <- c(1, 3)

  widget <- Widget_ScatterPlot(dfSummary, lLabels, selectedGroupIDs = selectedGroupIDs)

  expect_equal(widget$x$selectedGroupIDs, as.character(selectedGroupIDs))
})

test_that("Widget_ScatterPlot sets siteSelectLabelValue correctly", {
  dfSummary <- data.frame(GroupID = 1:3, Metric = 4:6, stringsAsFactors = FALSE)
  lLabels <- list(group = "TestGroup")

  widget <- Widget_ScatterPlot(dfSummary, lLabels)

  expect_equal(widget$x$siteSelectLabelValue, "Highlighted TestGroup: ")
})

test_that("Widget_ScatterPlot sets elementId correctly", {
  dfSummary <- data.frame(GroupID = 1:3, Metric = 4:6, stringsAsFactors = FALSE)
  lLabels <- list(group = "TestGroup")
  elementId <- "test-id"

  widget <- Widget_ScatterPlot(dfSummary, lLabels, elementId = elementId)
  expected_elementId <- paste(elementId, as.numeric(Sys.time()) * 1000, sep = "-")

  expect_true(grepl(paste0("^", elementId, "-"), widget$elementId))
})

test_that("Widget_ScatterPlot processes bHideDropdown correctly", {
  dfSummary <- data.frame(GroupID = 1:3, Metric = 4:6, stringsAsFactors = FALSE)
  lLabels <- list(group = "TestGroup")

  widget <- Widget_ScatterPlot(dfSummary, lLabels, bHideDropdown = TRUE)

  expect_equal(widget$x$bHideDropdown, TRUE)
})

test_that("Widget_ScatterPlot processes addSiteSelect correctly", {
  dfSummary <- data.frame(GroupID = 1:3, Metric = 4:6, stringsAsFactors = FALSE)
  lLabels <- list(group = "TestGroup")

  widget <- Widget_ScatterPlot(dfSummary, lLabels, addSiteSelect = FALSE)

  expect_equal(widget$x$addSiteSelect, FALSE)
})

