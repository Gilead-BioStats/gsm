dfSummary <- tibble::tibble(
  GroupID = c("10", "100", "101", "102", "103"),
  GroupType = rep("Site", 5),
  Numerator = seq(2,10,2),
  Denomicator = seq(10,50,10),
  Metric = c(0.02, 0.02, 0.02, 0.02, 0.02),
  Score = c(1,3,2.23489,1,1),
  Flag = c(0,2,1,0,0),
  MetricID = rep("kri0001", 5)
)

dfSite <- tibble::tibble(
  SiteID = c("10", "100", "101", "102", "103"),
  pi_last_name = c("Garcia", "Smith", "Baker", "Lee", "Stein"),
  country = c("Japan", "US", "Japan", "US", "China"),
  site_status = rep("Active", 5)
)


test_that("Empty data frames return default message", {
  dfSummary_empty <- dfSummary[-c(1:nrow(dfSummary)),]
  dfSite_empty <- dfSite[-c(1:nrow(dfSite)),]
  expect_equal(Report_MetricTable(dfSummary_empty, dfSite_empty), "Nothing flagged for this KRI.")
})

test_that("Correct data structure when proper dataframe is passed", {
  result <- Report_MetricTable(dfSummary, dfSite)
  expect_s3_class(result, "kableExtra")
  expect_true(grepl("<table", result))
  expect_true(grepl("100", result))
  expect_true(grepl("Smith", result))
  expect_true(grepl("US", result))
  expect_true(grepl("Japan", result))
})

test_that("Flag filtering works correctly", {
  result <- Report_MetricTable(dfSummary, dfSite)
  expect_s3_class(result, "kableExtra")
  expect_false(grepl("China", result))
})


test_that("Score rounding works correctly", {
  result <- Report_MetricTable(dfSummary, dfSite)
  expect_true(grepl("2.235", result))
})
