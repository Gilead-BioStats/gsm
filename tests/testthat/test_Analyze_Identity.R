source(testthat::test_path("testdata/data.R"))

dfInput <- Consent_Map_Raw(dfs = list(dfCONSENT = dfCONSENT, dfSUBJ = dfSUBJ))
dfTransformed <- Transform_Count(
  dfInput,
  strCountCol = "Count",
  strGroupCol = "SiteID"
)
dfAnalyzed <- Analyze_Identity(dfTransformed)

test_that("output created as expected and has correct structure", {
  expect_true(is.data.frame(dfAnalyzed))
  expect_equal(names(dfAnalyzed), c("GroupID",  "TotalCount", "Metric", "Score"))
  expect_equal(dfAnalyzed$Metric, dfAnalyzed$Score)
})

test_that("incorrect inputs throw errors", {
  expect_error(Analyze_Identity(list()))
  expect_error(Analyze_Identity("Hi"))
  expect_error(Analyze_Identity(dfTransformed, bQuiet = "Yes"))
  expect_error(Analyze_Identity(dfTransformed, strValueCol = "donut"))
  expect_error(Analyze_Identity(dfTransformed, strValueCol = c("donut", "phil")))
})


test_that("strValueCol works as intended", {
  dfTransformed <- dfTransformed %>%
    rename(customKRI = Metric)

  dfAnalyzed <- Analyze_Identity(dfTransformed, strValueCol = "customKRI")

  expect_silent(Analyze_Identity(dfTransformed, strValueCol = "customKRI"))
  expect_equal(names(dfAnalyzed), c("GroupID",  "TotalCount", "customKRI", "Score"))
})

test_that("bQuiet works as intended", {
  expect_snapshot(Analyze_Identity(dfTransformed, bQuiet = FALSE))
})
