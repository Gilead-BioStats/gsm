config <- MakeDfConfig(
  strMethod = "NormalApprox",
  strGroup = "Site",
  strAbbreviation = "AE",
  strMetric = "Adverse Event Rate",
  strNumerator = "Adverse Events",
  strDenominator = "Days on Treatment",
  vThreshold = c(-3, -2, 2, 3)
)

test_that("configuration data.frame is created as expected", {
  expect_true(is.data.frame(config))
  expect_type(config$thresholds, "list")
  expect_length(config$thresholds[[1]], 4)
  expect_snapshot(config)
})

test_that("configuration data.frame is not created when missing arguments", {

  expect_error(
    MakeDfConfig(
      strGroup = "Site",
      strAbbreviation = "AE",
      strMetric = "Adverse Event Rate",
      strNumerator = "Adverse Events",
      strDenominator = "Days on Treatment",
      vThreshold = c(-3, -2, 2, 3)
    )
  )

  expect_error(
    MakeDfConfig(
      strMethod = "NormalApprox",
      strAbbreviation = "AE",
      strMetric = "Adverse Event Rate",
      strNumerator = "Adverse Events",
      strDenominator = "Days on Treatment",
      vThreshold = c(-3, -2, 2, 3)
    )
  )

  expect_error(
    MakeDfConfig(
      strMethod = "NormalApprox",
      strGroup = "Site",
      strMetric = "Adverse Event Rate",
      strNumerator = "Adverse Events",
      strDenominator = "Days on Treatment",
      vThreshold = c(-3, -2, 2, 3)
    )
  )

  expect_error(
    MakeDfConfig(
      strMethod = "NormalApprox",
      strGroup = "Site",
      strAbbreviation = "AE",
      strNumerator = "Adverse Events",
      strDenominator = "Days on Treatment",
      vThreshold = c(-3, -2, 2, 3)
    )
  )

  expect_error(
    MakeDfConfig(
      strMethod = "NormalApprox",
      strGroup = "Site",
      strAbbreviation = "AE",
      strMetric = "Adverse Event Rate",
      strDenominator = "Days on Treatment",
      vThreshold = c(-3, -2, 2, 3)
    )
  )

  expect_error(
    MakeDfConfig(
      strMethod = "NormalApprox",
      strGroup = "Site",
      strAbbreviation = "AE",
      strMetric = "Adverse Event Rate",
      strNumerator = "Adverse Events",
      vThreshold = c(-3, -2, 2, 3)
    )
  )

  expect_error(
    MakeDfConfig(
      strMethod = "NormalApprox",
      strGroup = "Site",
      strAbbreviation = "AE",
      strMetric = "Adverse Event Rate",
      strNumerator = "Adverse Events",
      strDenominator = "Days on Treatment"
    )
  )


})


test_that("correct modelLabel values are returned", {

  NormalApprox <- MakeDfConfig(
    strMethod = "NormalApprox",
    strGroup = "Site",
    strAbbreviation = "AE",
    strMetric = "Adverse Event Rate",
    strNumerator = "Adverse Events",
    strDenominator = "Days on Treatment",
    vThreshold = c(-3, -2, 2, 3)
  )

  Poisson <- MakeDfConfig(
    strMethod = "Poisson",
    strGroup = "Site",
    strAbbreviation = "AE",
    strMetric = "Adverse Event Rate",
    strNumerator = "Adverse Events",
    strDenominator = "Days on Treatment",
    vThreshold = c(-3, -2, 2, 3)
  )

  Identity <- MakeDfConfig(
    strMethod = "Identity",
    strGroup = "Site",
    strAbbreviation = "AE",
    strMetric = "Adverse Event Rate",
    strNumerator = "Adverse Events",
    strDenominator = "Days on Treatment",
    vThreshold = c(-3, -2, 2, 3)
  )

  Fisher <- MakeDfConfig(
    strMethod = "Fisher",
    strGroup = "Site",
    strAbbreviation = "AE",
    strMetric = "Adverse Event Rate",
    strNumerator = "Adverse Events",
    strDenominator = "Days on Treatment",
    vThreshold = c(-3, -2, 2, 3)
  )

  expect_equal(NormalApprox$model, "Normal Approximation")
  expect_equal(NormalApprox$score, "Adjusted Z-Score")

  expect_equal(Poisson$model, "Poisson")
  expect_equal(Poisson$score, "Residual")

  expect_equal(Identity$model, "Identity")
  expect_equal(Identity$score, "Count")

  expect_equal(Fisher$model, "Fisher")
  expect_equal(Fisher$score, "P-value")
})
