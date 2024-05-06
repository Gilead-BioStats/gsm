# source(testthat::test_path("testdata/data.R"))
#
# dfInput <- Consent_Map_Raw(
#   dfs = list(
#     dfCONSENT = dfCONSENT,
#     dfSUBJ = dfSUBJ
#   )
# )
# dfTransformed <- Transform_Count(
#   result$test_Analyze_Identity$lData$dfInput,
#   strCountCol = "Numerator",
#   strGroupCol = "SiteID"
# )
# dfAnalyzed <- Analyze_Identity(dfTransformed)

wfs <- MakeWorkflowList(strNames="test_Analyze_Identity",
                        strPath = "tests/testthat/testdata/")
result <- Study_Assess(lAssessments=wfs)

dfTransformed <- result$test_Analyze_Identity$lData$dfTransformed
dfAnalyzed <- result$test_Analyze_Identity$lData$dfAnalyzed

test_that("output created as expected and has correct structure", {
  expect_true(is.data.frame(dfAnalyzed))
  expect_equal(names(dfAnalyzed), c("GroupID", "TotalCount", "Metric", "Score"))
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
  expect_equal(names(dfAnalyzed), c("GroupID", "TotalCount", "customKRI", "Score"))
})

# test_that("bQuiet works as intended", {
#   expect_snapshot(Analyze_Identity(dfTransformed, bQuiet = FALSE))
# })
