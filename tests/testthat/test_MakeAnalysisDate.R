test_that("NULL strAnalysisDate returns the current date", {
  today <- Sys.Date()

  analysis_date <- MakeAnalysisDate()

  expect_equal(today, analysis_date)
})

test_that("MakeAnalysisDate returns object of type 'date'", {
  analysis_date <- MakeAnalysisDate()
  custom_analysis_date <- MakeAnalysisDate("1979-10-12")

  expect_equal(class(analysis_date), "Date")
  expect_equal(class(custom_analysis_date), "Date")
})

test_that("Incorrectly formatted date defaults to current date", {
  expect_message(MakeAnalysisDate("123-456"))
})
