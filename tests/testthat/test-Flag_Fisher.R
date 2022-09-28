source(testthat::test_path("testdata/data.R"))

dfInput <- LB_Map_Raw(dfs = list(dfLB = dfLB, dfSUBJ = dfSUBJ))

dfTransformed <- Transform_Rate(
  dfInput = dfInput,
  strGroupCol = "SiteID",
  strNumeratorCol = "Count",
  strDenominatorCol = "Total"
)

dfAnalyzed <- Analyze_Identity(dfTransformed)

test_that("output is created as expected", {

  dfFlagged <- Flag_Fisher(dfAnalyzed, vThreshold = c(-.05, .05))
  expect_true(is.data.frame(dfFlagged))
  expect_equal(sort(unique(dfInput$SiteID)), sort(dfFlagged$GroupID))
  expect_equal(names(dfFlagged), c("GroupID", "Numerator", "Denominator", "Metric", "Score", "Flag"))

})

test_that("incorrect inputs throw errors", {
  expect_error(Flag_Fisher(list(), vThreshold = c(-2, 2)), "dfAnalyzed is not a data frame")
  expect_error(Flag_Fisher(dfAnalyzed, "1", "2"))
  expect_error(Flag_Fisher(dfAnalyzed, vThreshold = c("-2", "2")), "vThreshold is not numeric")
})
