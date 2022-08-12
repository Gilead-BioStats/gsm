source(testthat::test_path("testdata/data.R"))

dfInput <- Consent_Map_Raw(dfs = list(dfCONSENT = dfCONSENT, dfSUBJ = dfSUBJ))
dfTransformed <- Transform_EventCount(
  dfInput,
  strCountCol = "Count",
  strGroupCol = "SiteID",
  strKRILabel = "Test Label"
)
dfAnalyzed <- Analyze_Identity(dfTransformed)

test_that("output created as expected and has correct structure", {
  expect_true(is.data.frame(dfAnalyzed))
  expect_equal(names(dfAnalyzed), c("GroupID", "GroupLabel", "N", "TotalCount", "KRI", "KRILabel", "Score", "ScoreLabel"))
  expect_equal(dfAnalyzed$KRI, dfAnalyzed$Score)
  expect_equal(dfAnalyzed$KRILabel, dfAnalyzed$ScoreLabel)
})

test_that("incorrect inputs throw errors", {
  expect_error(Analyze_Identity(list()))
  expect_error(Analyze_Identity("Hi"))
  expect_error(Analyze_Identity(dfTransformed, bQuiet = "Yes"))
  expect_error(Analyze_Identity(dfTransformed, strValueCol = "donut"))
  expect_error(Analyze_Identity(dfTransformed, strLabelCol = "mango"))
  expect_error(Analyze_Identity(dfTransformed, strValueCol = c("donut", "phil")))
  expect_error(Analyze_Identity(dfTransformed, strLabelCol = c("donut", "phil")))
})

test_that("error given if required column not found", {
  expect_error(Analyze_Identity(dfAnalyzed %>% rename("x" = KRI)))
  expect_error(Analyze_Identity(dfAnalyzed %>% rename("x" = KRILabel)))
})

test_that("strValueCol works as intended", {
  dfTransformed <- dfTransformed %>%
    rename(customKRI = KRI)

  dfAnalyzed <- Analyze_Identity(dfTransformed, strValueCol = "customKRI")

  expect_silent(Analyze_Identity(dfTransformed, strValueCol = "customKRI"))
  expect_equal(names(dfAnalyzed), c(
    "GroupID", "GroupLabel", "N", "TotalCount", "customKRI", "KRILabel",
    "Score", "ScoreLabel"
  ))
})

test_that("strLabelCol works as intended", {
  dfTransformed <- dfTransformed %>%
    rename(customKRILabel = KRILabel)

  dfAnalyzed <- Analyze_Identity(dfTransformed, strLabelCol = "customKRILabel")

  expect_silent(Analyze_Identity(dfTransformed, strLabelCol = "customKRILabel"))
  expect_equal(names(dfAnalyzed), c(
    "GroupID", "GroupLabel", "N", "TotalCount", "KRI", "customKRILabel",
    "Score", "ScoreLabel"
  ))
})

test_that("bQuiet works as intended", {
  expect_snapshot(Analyze_Identity(dfTransformed, bQuiet = FALSE))
})
