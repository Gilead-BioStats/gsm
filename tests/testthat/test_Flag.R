source(testthat::test_path("testdata/data.R"))

data <- AE_Map_Adam(dfs = list(dfADSL = dfADSL, dfADAE = dfADAE)) %>%
  Transform_Rate(
    strNumeratorCol = "Count",
    strDenominatorCol = "Exposure",
    strGroupCol = "SiteID"
    )

dfPoisson <- Analyze_Poisson(data)


# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  flag <- Flag(dfPoisson, vThreshold = c(-1, 1))
  expect_true(is.data.frame(flag))
  expect_equal(sort(unique(dfPoisson$GroupID)), sort(flag$GroupID))
  expect_true(all(names(dfPoisson) %in% names(flag)))
  expect_equal(
    names(flag),
    c("GroupID", "N", "Numerator", "Denominator", "Metric", "Score",
      "PredictedCount", "Flag")
  )
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors", {
  expect_error(Flag(list(), -1, 1))
  expect_error(Flag("Hi", -1, 1))
  expect_error(Flag(dfPoisson, "1", "2"))
  expect_error(Flag(dfPoisson, vThreshold = c(NA, 1), strColumn = 1.0, strValueColumn = "Estimate"))
  expect_error(Flag(dfPoisson, vThreshold = "1", strValueColumn = "Estimate"))
  expect_error(Flag(dfPoisson, vThreshold = 0.5, strValueColumn = "Estimate"))
  expect_error(Flag(dfPoisson, vThreshold = c(NA, 1), strColumn = "PValue1", strValueColumn = "Estimate"))
  expect_error(Flag(dfPoisson, vThreshold = c(NA, 1), strValueColumn = "Mean"))
})


# custom tests ------------------------------------------------------------
test_that("strValueColumn paramter works as intended", {
  dfFlagged <- Flag(dfPoisson, vThreshold = c(-1, 1), strValueColumn = "PredictedCount")
  expect_equal(dfFlagged$Flag[1], 1)
  dfFlagged <- Flag(dfPoisson, vThreshold = c(-1, 1), strValueColumn = NULL)
  expect_equal(dfFlagged$Flag[1], 1)
})

test_that("vThreshold parameter works as intended", {
  sim1 <- Flag(data.frame(GroupID = seq(1:100), vals = seq(1:100)), strColumn = "vals", vThreshold = c(10, NA))
  expect_equal(sim1$Flag, c(rep(-1, 9), rep(0, 91)))
  sim2 <- Flag(data.frame(GroupID = seq(1:100), vals = seq(1:100)), strColumn = "vals", vThreshold = c(NA, 91))
  expect_equal(sim2$Flag, c(rep(1, 9), rep(0, 91)))
  sim3 <- Flag(data.frame(GroupID = seq(1:100), vals = seq(1:100)), strColumn = "vals", vThreshold = c(2, 91))
  expect_equal(sim3$Flag, c(rep(1, 9), -1, rep(0, 90)))
  sim4 <- Flag(data.frame(GroupID = seq(1:201), vals = seq(from = -100, to = 100)), strColumn = "vals", vThreshold = c(-91, 91))
  expect_equal(sim4$Flag, c(rep(1, 9), rep(-1, 9), rep(0, 183)))
})

test_that("NA values in strColumn result in NA in Flag column", {
  NAsim <- Flag(data.frame(GroupID = seq(1:100), vals = c(seq(1:90), rep(NA, 10))), strColumn = "vals", vThreshold = c(10, NA))
  expect_equal(NAsim$Flag, c(rep(-1, 9), rep(0, 81), rep(NA, 10)))
})
