test_that("all input data frames must be non-null", {
  expect_error(Input_Rate(NULL, data.frame(), data.frame()))
  expect_error(Input_Rate(data.frame(), NULL, data.frame()))
  expect_error(Input_Rate(data.frame(), data.frame(), NULL))
})

test_that("strNumeratorMethod and strDenominatorMethod must be 'Count' or 'Sum'", {
  test_df <- data.frame(SubjectID = 1:5)
  expect_error(Input_Rate(test_df, test_df, test_df, strNumeratorMethod = "Invalid", strDenominatorMethod = "Count"))
  expect_error(Input_Rate(test_df, test_df, test_df, strNumeratorMethod = "Sum", strDenominatorMethod = "Invalid"))
  expect_error(Input_Rate(test_df, test_df, test_df, strNumeratorMethod = "Average", strDenominatorMethod = "Average"))
})

test_that("strNumeratorCol and strDenominatorCol must be provided when respective method is 'Sum'", {
  test_df <- data.frame(SubjectID = 1:5, Amount = 1:5)
  expect_error(Input_Rate(test_df, test_df, test_df, strNumeratorMethod = "Sum"))
  expect_error(Input_Rate(test_df, test_df, test_df, strDenominatorMethod = "Sum"))
})

test_that("strSubjectCol must exist in all data frames", {
  test_df_1 <- data.frame(SubjectID = 1:5)
  test_df_2 <- data.frame(DifferentID = 1:5)
  expect_error(Input_Rate(test_df_1, test_df_1, test_df_2, strSubjectCol = "SubjectID"))
})

test_that("basic functionality with count method works", {
  subjects <- data.frame(
    SubjectID = 1:3,
    GroupID = 10:12
  )
  numerators <- data.frame(
    SubjectID = c(1, 1, 2),
    GroupID = 10:12,
    Count = c(6, 13, 8)
  )
  denominators <- data.frame(
    SubjectID = c(1, 2, 3),
    GroupID = 10:12,
    Count = c(6, 13, 8)
  )

  result <- Input_Rate(subjects, numerators, denominators)
  expected <- data.frame(
    SubjectID = 1:3,
    GroupID = 10:12,
    GroupLevel = "GroupID",
    Numerator = c(2, 1, 0),
    Denominator = c(1, 1, 1),
    Metric = c(2, 1, 0)
  )
  expect_equal(result, expected)
})

test_that("test with method 'Sum' where columns are provided", {
  subjects <- data.frame(
    SubjectID = 1:3,
    GroupID = 10:12
  )
  numerators <- data.frame(
    SubjectID = c(1, 1, 2),
    GroupID = 10:12,
    Amount = c(10, 5, 10)
  )
  denominators <- data.frame(
    SubjectID = c(1, 2, 3),
    GroupID = 10:12,
    Amount = c(15, 5, 20)
  )

  result <- Input_Rate(subjects, numerators, denominators, strNumeratorMethod = "Sum", strDenominatorMethod = "Sum", strNumeratorCol = "Amount", strDenominatorCol = "Amount")
  expected <- data.frame(
    SubjectID = 1:3,
    GroupID = 10:12,
    GroupLevel = "GroupID",
    Numerator = c(15, 10, 0),
    Denominator = c(15, 5, 20),
    Metric = c(1, 2, 0)
  )
  expect_equal(result, expected)
})

test_that("handling of zero denominators and missing data", {
  subjects <- data.frame(
    SubjectID = 1:4,
    GroupID = 10:13
  )
  numerators <- data.frame(
    SubjectID = c(1, 1),
    GroupID = 10:11
  )
  denominators <- data.frame(
    SubjectID = c(1, 2),
    GroupID = 12:13
  )

  result <- Input_Rate(subjects, numerators, denominators)

  expected <- data.frame(
    SubjectID = 1:4,
    GroupID = 10:13,
    GroupLevel = "GroupID",
    Numerator = c(2, 0, 0, 0),
    Denominator = c(1, 1, 0, 0),
    Metric = c(2, 0, NaN, NaN) # NaN because denominator is zero
  )

  expect_equal(result, expected)
})

test_that("yaml workflow produces same table as R function", {
  source(test_path("testdata", "create_double_data.R"), local = TRUE)
  expect_equal(dfInput$SubjectID, lResults$Analysis_Input$SubjectID)
  expect_equal(dim(dfInput), dim(lResults$Analysis_Input))
})

test_that("Input_Rate applies filters", {
  subjects <- data.frame(
    SubjectID = 1:4,
    GroupID = 10:13,
    filterthing = 1:4
  )
  numerators <- data.frame(
    SubjectID = c(1, 1, 2, 3),
    GroupID = 10:13,
    Amount = c(10, 5, 10, 5),
    filterthing = 1:4
  )
  denominators <- data.frame(
    SubjectID = c(1, 2, 3, 4),
    GroupID = 10:13,
    Amount = c(15, 5, 20, 20),
    filterthing = 1:4
  )

  result <- Input_Rate(
    subjects,
    numerators,
    denominators,
    strNumeratorMethod = "Sum",
    strDenominatorMethod = "Sum",
    strNumeratorCol = "Amount",
    strDenominatorCol = "Amount",
    strFilterSubjects = "filterthing != 4",
    strFilterNumerator = "filterthing != 4",
    strFilterDenominator = "filterthing != 4",
  )
  expected <- data.frame(
    SubjectID = 1:3,
    GroupID = 10:12,
    GroupLevel = "GroupID",
    Numerator = c(15, 10, 0),
    Denominator = c(15, 5, 20),
    Metric = c(1, 2, 0)
  )
  expect_equal(result, expected)

  result <- Input_Rate(
    subjects,
    numerators,
    denominators,
    strNumeratorMethod = "Sum",
    strDenominatorMethod = "Sum",
    strNumeratorCol = "Amount",
    strDenominatorCol = "Amount",
    strFilterSubjects = "filterthing != 4, SubjectID %in% 1:3",
    strFilterNumerator = "filterthing != 4",
    strFilterDenominator = "filterthing != 4",
  )
  expect_equal(result, expected)

  result <- Input_Rate(
    subjects,
    numerators,
    denominators,
    strNumeratorMethod = "Sum",
    strDenominatorMethod = "Sum",
    strNumeratorCol = "Amount",
    strDenominatorCol = "Amount",
    strFilterSubjects = c("filterthing != 4", "SubjectID %in% 1:3"),
    strFilterNumerator = "filterthing != 4",
    strFilterDenominator = "filterthing != 4",
  )
  expect_equal(result, expected)
})
