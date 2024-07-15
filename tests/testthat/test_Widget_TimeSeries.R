test_that("Widget_TimeSeries processes dfResults correctly", {

  widget <- suppressWarnings(Widget_TimeSeries(sampleResults,
                                               sampleMetrics %>% as.list(),
                                               strOutcome = "Metric"))

  dfResults_expected <- sampleResults %>%
    jsonlite::toJSON(na = "string")

  expect_equal(widget$x$dfResults, dfResults_expected)
})


test_that("Widget_TimeSeries handles dfGroups correctly", {
  widget <- Widget_TimeSeries(sampleResults,
                              sampleMetrics %>% as.list(),
                              dfGroups = sampleGroups,
                              strOutcome = "Score") %>%
    suppressWarnings()

  dfGroups_expected <- sampleGroups %>%
    jsonlite::toJSON(na = "string")

  expect_equal(widget$x$dfGroups, dfGroups_expected)
})

test_that("Widget_TimeSeries sets vThreshold correctly", {
  vThreshold <- c(1, 2, 3)

  widget <- Widget_TimeSeries(sampleResults,
                            sampleMetrics %>% as.list(),
                            vThreshold = vThreshold)

  vThreshold_json <- jsonlite::toJSON(vThreshold, na = "string")
  expect_equal(widget$x$vThreshold, vThreshold_json)
})
