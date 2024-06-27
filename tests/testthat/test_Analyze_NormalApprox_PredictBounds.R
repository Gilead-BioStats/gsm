test_that("Analyze_NormalApprox_PredictBounds handles missing vThreshold correctly", {
  dfTransformed <- Transform_Rate(sampleInput)

  dfBounds <- Analyze_NormalApprox_PredictBounds(dfTransformed, vThreshold = NULL)

  expect_equal(sort(unique(dfBounds$Threshold)), sort(c(-3, -2, 0, 2, 3)))
})

test_that("Analyze_NormalApprox_PredictBounds processes data correctly", {
  dfTransformed <- Transform_Rate(sampleInput)

  dfBounds <- Analyze_NormalApprox_PredictBounds(dfTransformed)

  expect_true(all(c("Threshold", "LogDenominator", "Denominator", "Numerator") %in% names(dfBounds)))
  expect_equal(dfBounds$Threshold[1], -3)
})

test_that("Analyze_NormalApprox_PredictBounds handles edge cases for vThreshold", {
  dfTransformed <- Transform_Rate(sampleInput)

  dfBounds <- Analyze_NormalApprox_PredictBounds(dfTransformed, vThreshold = c(0))

  expect_equal(unique(dfBounds$Threshold), 0)
})
