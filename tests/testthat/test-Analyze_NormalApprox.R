test_that("binary output created as expected and has correct structure", {
  dfTransformed <- tibble::tibble(
    GroupID = c("166", "76", "86"),
    GroupLevel = c("site", "site", "site"),
    Numerator = c(0, 1, 0),
    Denominator = c(1, 1, 1),
    Metric = c(0, 1, 0)
  )
  expect_message(
    {
      binary <- Analyze_NormalApprox(dfTransformed, strType = "binary")
    },
    "`OverallMetric`,"
  )

  expect_true(is.data.frame(binary))
  expect_equal(names(binary), c("GroupID", "GroupLevel", "Numerator", "Denominator", "Metric", "OverallMetric", "Factor", "Score"))
  expect_type(binary$GroupID, "character")
  expect_type(c(binary$Numerator, binary$Denominator, binary$Metric, binary$OverallMetric, binary$Factor, binary$Score), "double")
  expect_equal(unique(binary$GroupID), c("166", "86", "76"))
})

test_that("rate output created as expected and has correct structure", {
  dfTransformed <- Transform_Rate(analyticsInput)

  rate <- quiet_Analyze_NormalApprox(dfTransformed, strType = "rate")

  expect_true(is.data.frame(rate))
  expect_equal(names(rate), c("GroupID", "GroupLevel", "Numerator", "Denominator", "Metric", "OverallMetric", "Factor", "Score"))
  expect_type(rate$GroupID, "character")
  expect_type(c(rate$Numerator, rate$Denominator, rate$Metric, rate$OverallMetric, rate$Factor, rate$Score), "double")
  expect_equal(unique(rate$GroupID)[1:5], c("143", "10", "172", "173", "140"))
})

test_that("incorrect inputs throw errors", {
  dfTransformed <- tibble::tibble(
    GroupID = c("166", "76", "86"),
    GroupLevel = c("site", "site", "site"),
    Numerator = c(0, 1, 0),
    Denominator = c(1, 1, 1),
    Metric = c(0, 1, 0)
  )
  expect_error(Analyze_NormalApprox(list()))
  expect_error(Analyze_NormalApprox("Hi"))
  expect_error(Analyze_NormalApprox(dfTransformed, strOutcome = ":("))
  expect_error(Analyze_NormalApprox(dfTransformed, strType = "sadie"))
})

test_that("error given if required column not found", {
  dfTransformed <- tibble::tibble(
    GroupID = c("166", "76", "86"),
    GroupLevel = c("site", "site", "site"),
    Numerator = c(0, 1, 0),
    Denominator = c(1, 1, 1),
    Metric = c(0, 1, 0)
  )
  expect_error(Analyze_NormalApprox(dfTransformed %>% select(-GroupID)))
  expect_error(Analyze_NormalApprox(dfTransformed %>% select(-Numerator)))
  expect_error(Analyze_NormalApprox(dfTransformed %>% select(-Denominator)))
  expect_error(Analyze_NormalApprox(dfTransformed %>% select(-Metric)))
})

test_that("NAs are handled correctly", {
  dfTransformed <- tibble::tibble(
    GroupID = c("166", "76", "86"),
    GroupLevel = c("site", "site", "site"),
    Numerator = c(0, 1, 0),
    Denominator = c(1, 1, 1),
    Metric = c(0, 1, 0)
  )
  createNA <- function(data, variable) {
    data[[variable]][[1]] <- NA
    return(quiet_Analyze_NormalApprox(data))
  }
  expect_error(createNA(data = dfTransformed, variable = "GroupID"))
})

test_that("Score (z_i) is 0 when vMu is 1 or 0", {
  dfTransformed <- tibble::tibble(
    GroupID = c("166", "76", "86"),
    GroupLevel = c("site", "site", "site"),
    Numerator = c(0, 1, 0),
    Denominator = c(1, 1, 1),
    Metric = c(0, 1, 0)
  )
  # z_i == 1
  result_one <- quiet_Analyze_NormalApprox(
    dfTransformed %>%
      mutate(Numerator = 1, Denominator = 1, Metric = 1),
    strType = "rate"
  )

  # z_i == 0
  result_zero <- quiet_Analyze_NormalApprox(
    dfTransformed %>%
      mutate(Numerator = 0, Denominator = 1, Metric = 0),
    strType = "rate"
  )

  expect_true(all(result_one$Score == 0))
  expect_true(all(result_zero$Score == 0))
})

test_that("yaml workflow produces same table as R function", {
  source(test_path("testdata", "create_double_data.R"), local = TRUE)
  expect_equal(dfAnalyzed$Metric, lResults$Metric_kri0001$analyzed$Metric)
  expect_equal(dim(dfAnalyzed), dim(lResults$Metric_kri0001$analyzed))
})
