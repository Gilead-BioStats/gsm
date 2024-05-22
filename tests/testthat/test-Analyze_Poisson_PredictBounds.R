test_that("Analyze_Poisson_PredictBounds handles missing vThreshold correctly", {
  dfTransformed <- data.frame(
    Denominator = c(100, 200, 300),
    Numerator = c(10, 20, 30),
    stringsAsFactors = FALSE
  )

  dfBounds <- Analyze_Poisson_PredictBounds(dfTransformed, vThreshold = NULL)

  expect_equal(sort(unique(dfBounds$Threshold)), sort(c(-5, 0, 5)))
})

test_that("Analyze_Poisson_PredictBounds processes data correctly", {
  dfTransformed <- data.frame(
    Denominator = c(100, 200, 300),
    Numerator = c(10, 20, 30),
    stringsAsFactors = FALSE
  )

  dfBounds <- Analyze_Poisson_PredictBounds(dfTransformed)

  expect_true(all(c("Threshold", "LogDenominator", "Denominator", "Numerator") %in% names(dfBounds)))
  expect_equal(dfBounds$Threshold[1], -5)
})

test_that("Analyze_Poisson_PredictBounds handles edge cases for vThreshold", {
  dfTransformed <- data.frame(
    Denominator = c(100, 200, 300),
    Numerator = c(10, 20, 30),
    stringsAsFactors = FALSE
  )

  dfBounds <- Analyze_Poisson_PredictBounds(dfTransformed, vThreshold = c(0))

  expect_equal(unique(dfBounds$Threshold), 0)
})

test_that("Analyze_Poisson_PredictBounds calculates correct bounds", {
  dfTransformed <- data.frame(
    Denominator = c(100, 200, 300),
    Numerator = c(10, 20, 30),
    stringsAsFactors = FALSE
  )

  dfBounds <- Analyze_Poisson_PredictBounds(dfTransformed)

  cModel <- glm(
    Numerator ~ offset(log(Denominator)),
    family = poisson(link = "log"),
    data = dfTransformed
  )

  expect_true(all(dfBounds$Numerator >= 0))
  expect_true(all(dfBounds$Denominator > 0))
  expect_true(!any(is.nan(dfBounds$Numerator)))
})
