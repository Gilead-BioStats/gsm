# Prep test data
dfSubjects <- data.frame(
  SubjectID = 1:10,
  SiteID = rep(1:2, each = 5),
  StudyID = rep(1:2, each = 5),
  CountryID = rep("CountryA", times = 10)
)

dfNumerator <- data.frame(
  SubjectID = 1:10,
  Value = c(seq(10, 50, 10), seq(50, 10, -10))
)

dfDenominator <- data.frame(
  SubjectID = 1:10,
  Value = rep(seq(2, 10, 2), 2)
)

dfs <- list(dfSubjects = dfSubjects, dfNumerator = dfNumerator, dfDenominator = dfDenominator)

test_that("Should stop if dfs is NULL", {
  expect_error(Input_Rate(dfs = NULL), "dfs, must be provided")
})

test_that("Correct error on invalid strNumeratorMethod or strDenominatorMethod", {
  expect_error(Input_Rate(dfs = dfs, strNumeratorMethod = "InvalidMethod"), 'strNumeratorMethod and strDenominator method must be \'Count\' or \'Sum\'')
  expect_error(Input_Rate(dfs = dfs, strDenominatorMethod = "Invalid"),
               'strNumeratorMethod and strDenominator method must be \'Count\' or \'Sum\'')
})

test_that("Stops if strNumeratorCol or strDenominatorCol is not provided when needed", {
  expect_error(Input_Rate(dfs = dfs, strNumeratorMethod = "Sum"),
               'strNumeratorCol must be provided when strNumeratorMethod is \'Sum\'')
  expect_error(Input_Rate(dfs = dfs, strDenominatorMethod = "Sum"),
               'strDenominatorCol must be provided when strDenominatorMethod is \'Sum\'')
})

test_that("Stops if mandatory data frames or columns are missing", {
  broken_dfs <- list(dfNumerator = dfNumerator, dfDenominator = dfDenominator)
  expect_error(Input_Rate(dfs = broken_dfs),
               "dfs must contain dfSubjects, dfNumerator, and dfDenominator")

  brokenSubjects <- dfSubjects[, -which(names(dfSubjects) %in% "StudyID"), drop = FALSE]
  broken_dfs <- list(dfSubjects = brokenSubjects, dfNumerator = dfNumerator, dfDenominator = dfDenominator)
  expect_error(Input_Rate(dfs = broken_dfs),
               "dfSubjects must contain columns for SubjectID, SiteID, StudyID, and CountryID")
})

test_that("Calculates rate correctly with Count method", {
  df <- Input_Rate(dfs = dfs, strNumeratorMethod = "Count", strDenominatorMethod = "Count")
  expected <- c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1)
  expect_equal(df$Rate, expected)
})

test_that("Calculates rate correctly with Sum method using provided columns", {
  df <- Input_Rate(dfs = dfs, strNumeratorMethod = "Sum", strDenominatorMethod = "Sum",
                   strNumeratorCol = "Value", strDenominatorCol = "Value")
  expected <- c(5, 5, 5, 5, 5, 25, 10, 5, 2.5, 1)
  expect_equal(df$Rate, expected)
})

test_that("Works with partial and uneven data sets", {
  partialDenominator <- dfDenominator[-c(4,5), ]
  custom_dfs <- list(dfSubjects = dfSubjects, dfNumerator = dfNumerator, dfDenominator = partialDenominator)
  df <- Input_Rate(dfs = custom_dfs, strNumeratorMethod = "Sum", strDenominatorMethod = "Sum", strNumeratorCol = "Value", strDenominatorCol = "Value")
  expected_rate <- c(5, 5, 5, Inf, Inf, 25, 10, 5, 2.5, 1)
  expect_equal(df$Rate, expected_rate)
})
