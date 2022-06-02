source(testthat::test_path("testdata/data.R"))

ae_input <- AE_Map_Adam(dfs = list(dfADSL = dfADSL, dfADAE = dfADAE))

dfTransformed <- Transform_EventCount(ae_input, strCountCol = "Count", strExposureCol = "Exposure")
dfAnalyzed <- gsm::Analyze_Poisson(dfTransformed)
dfFlagged <- gsm::Flag(dfAnalyzed, strColumn = "Residuals", vThreshold = c(-5, 5))

test_that("output created as expected and has correct structure", {
  ae_default <- Summarize(dfFlagged, "Residuals")
  expect_true(is.data.frame(ae_default))
  expect_equal(names(ae_default), c("SiteID", "N", "Score", "Flag"))
  expect_equal(sort(unique(ae_input$SiteID)), sort(ae_default$SiteID))

  ae_finding <- Summarize(dfFlagged, "Residuals", list(Assessment = "Safety", Label = "Test Assessment"))
  expect_true(is.data.frame(ae_finding))
  expect_equal(names(ae_finding), c("SiteID", "N", "Score", "Flag", "Assessment", "Label"))
  expect_equal(sort(unique(ae_input$SiteID)), sort(ae_finding$SiteID))
})

test_that("incorrect inputs throw errors", {
  expect_error(Summarize(list()))
  expect_error(Summarize("Hi"))
  expect_error(Summarize(ae_flag, 12312))
  expect_error(Summarize(dfFlagged, strScoreCol = "wombat"))
})

test_that("invalid lTags throw error", {
  expect_error(Summarize(dfFlagged, strScoreCol = "Residuals", lTags = "hi mom"))
  expect_error(Summarize(dfFlagged, strScoreCol = "Residuals", lTags = list("hi", "mom")))
  expect_error(Summarize(dfFlagged, strScoreCol = "Residuals", lTags = list(greeting = "hi", "mom")))
  expect_silent(Summarize(dfFlagged, strScoreCol = "Residuals", lTags = list(greeting = "hi", person = "mom")))
})

test_that("output is correctly sorted by Flag and Score", {
  sim1 <- data.frame(SiteID = seq(1:100), N = seq(1:100), PValue = rep(NA, 100), ThresholdLow = rep(10, 100), ThresholdHigh = rep(NA, 100), Flag = c(rep(-1, 9), rep(0, 91)))
  expect_equal(Summarize(sim1)$Flag, c(rep(-1, 9), rep(0, 91)))

  sim1 <- data.frame(SiteID = seq(1, 100), N = seq(1, 100), PValue = c(seq(1, 5), seq(6, 1), rep(11, 89)), ThresholdLow = rep(10, 100), ThresholdHigh = rep(NA, 100), Flag = c(rep(-1, 9), rep(0, 91)))
  expect_equal(Summarize(sim1, strScoreCol = "PValue")$Score, c(6, 5, 5, 4, 4, 3, 3, 2, 1, rep(11, 89), 2, 1))
})
