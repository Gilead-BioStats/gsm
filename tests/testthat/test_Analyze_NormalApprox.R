source(testthat::test_path("testdata/data.R"))

dfInput <- Disp_Map_Raw(
  dfs = list(
    dfSDRGCOMP = dfSDRGCOMP,
    dfSTUDCOMP = dfSTUDCOMP,
    dfSUBJ = dfSUBJ
  )
)

dfTransformed <- Transform_Rate(
  dfInput = dfInput,
  strGroupCol = "SiteID",
  strNumeratorCol = "Count",
  strDenominatorCol = "Total"
)

################################################################################

test_that("binary output created as expected and has correct structure", {
  binary <- Analyze_NormalApprox(dfTransformed, strType = "binary")

  expect_true(is.data.frame(binary))
  expect_equal(names(binary), c("GroupID", "Numerator", "Denominator", "Metric", "OverallMetric", "Factor", "Score"))
  expect_type(binary$GroupID, "character")
  expect_type(c(binary$Numerator, binary$Denominator, binary$Metric, binary$OverallMetric, binary$Factor, binary$Score), "double")
  expect_equal(unique(binary$GroupID), c("166", "86", "76"))
})

################################################################################

test_that("rate output created as expected and has correct structure", {
  dfInput <- AE_Map_Raw(
    dfs = list(
      dfAE = dfAE,
      dfSUBJ = dfSUBJ
    )
  )

  dfTransformed <- Transform_Rate(
    dfInput = dfInput,
    strGroupCol = "SiteID",
    strNumeratorCol = "Count",
    strDenominatorCol = "Exposure"
  )

  rate <- Analyze_NormalApprox(dfTransformed, strType = "rate")

  expect_true(is.data.frame(rate))
  expect_equal(names(rate), c("GroupID", "Numerator", "Denominator", "Metric", "OverallMetric", "Factor", "Score"))
  expect_type(rate$GroupID, "character")
  expect_type(c(rate$Numerator, rate$Denominator, rate$Metric, rate$OverallMetric, rate$Factor, rate$Score), "double")
  expect_equal(unique(rate$GroupID), c("166", "86", "76"))
})

################################################################################

test_that("incorrect inputs throw errors", {
  expect_error(Analyze_NormalApprox(list()))
  expect_error(Analyze_NormalApprox("Hi"))
  expect_error(Analyze_NormalApprox(dfTransformed, strOutcome = data.frame()))
  expect_error(Analyze_NormalApprox(dfTransformed, strOutcome = ":("))
  expect_error(Analyze_NormalApprox(dfTransformed, strType = "sadie"))
})

################################################################################

test_that("error given if required column not found", {
  expect_error(Analyze_NormalApprox(dfTransformed %>% select(-GroupID)))
  expect_error(Analyze_NormalApprox(dfTransformed %>% select(-Numerator)))
  expect_error(Analyze_NormalApprox(dfTransformed %>% select(-Denominator)))
  expect_error(Analyze_NormalApprox(dfTransformed %>% select(-Metric)))
})

################################################################################

test_that("NAs are handled correctly", {
  createNA <- function(data, variable) {
    data[[variable]][[1]] <- NA
    return(Analyze_NormalApprox(data))
  }
  expect_error(createNA(data = dfTransformed, variable = "GroupID"))
})

################################################################################

test_that("Score (z_i) is 0 when vMu is 1 or 0", {
  # z_i == 1
  result_one <- Analyze_NormalApprox(
    dfTransformed %>%
      mutate(Numerator = 1, Denominator = 1, Metric = 1),
    strType = "rate"
  )

  # z_i == 0
  result_zero <- Analyze_NormalApprox(
    dfTransformed %>%
      mutate(Numerator = 0, Denominator = 1, Metric = 0),
    strType = "rate"
  )

  expect_true(all(result_one$Score == 0))
  expect_true(all(result_zero$Score == 0))
})


test_that("bQuiet works as intended", {
  expect_snapshot(Analyze_NormalApprox(dfTransformed, bQuiet = FALSE))
})
