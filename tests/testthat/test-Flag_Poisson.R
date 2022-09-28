source(testthat::test_path("testdata/data.R"))

dfInput <- AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ))

dfTransformed <- Transform_Rate(
  dfInput = dfInput,
  strGroupCol = "SiteID",
  strNumeratorCol = "Count",
  strDenominatorCol = "Exposure"
)

dfAnalyzed <- Analyze_Poisson(dfTransformed)

test_that("output is created as expected", {

  dfFlagged <- Flag_Poisson(dfAnalyzed, vThreshold = c(-.05, -.005, .005, .05))
  expect_true(is.data.frame(dfFlagged))
  expect_equal(sort(unique(dfInput$SiteID)), sort(dfFlagged$GroupID))
  expect_equal(names(dfFlagged), c("GroupID", "Numerator", "Denominator", "Metric", "Score", "PredictedCount", "Flag"))

})

test_that("incorrect inputs throw errors", {
  expect_error(Flag_Poisson(list(), vThreshold = c(-2, -1, 1, 2)), "dfAnalyzed is not a data frame")
  expect_error(Flag_Poisson(dfAnalyzed, "1", "2"))

})




