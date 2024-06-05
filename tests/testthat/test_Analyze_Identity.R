dfTransformed <- Transform_Rate(sampleInput)
dfAnalyzed <- Analyze_Identity(dfTransformed)

test_that("output created as expected and has correct structure", {
  expect_true(is.data.frame(dfAnalyzed))
  expect_equal(names(dfAnalyzed), c("GroupID", "GroupLevel", "Numerator", "Denominator", "Metric", "Score"))
  expect_equal(dfAnalyzed$Metric, dfAnalyzed$Score)
})

test_that("incorrect inputs throw errors", {
  expect_error(Analyze_Identity(list()))
  expect_error(Analyze_Identity("Hi"))
  expect_error(Analyze_Identity(df, bQuiet = "Yes"))
  expect_error(Analyze_Identity(df, strValueCol = "donut"))
  expect_error(Analyze_Identity(df, strValueCol = c("donut", "phil")))
})


test_that("strValueCol works as intended", {
  dfTransformed <- dfTransformed %>%
    rename(customKRI = Metric)

  dfAnalyzed <- Analyze_Identity(dfTransformed, strValueCol = "customKRI")

  #expect_silent(Analyze_Identity(dfTransformed, strValueCol = "customKRI"))
  expect_equal(names(dfAnalyzed), c("GroupID", "GroupLevel", "Numerator", "Denominator", "customKRI", "Score"))
})

