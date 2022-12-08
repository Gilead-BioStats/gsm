source(testthat::test_path("testdata/data.R"))

test_that("Output is produced", {
  # poisson model
  dfInput <- AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ))
  SafetyAE <- AE_Assess(dfInput, strMethod = "Poisson")
  dfBounds <- Analyze_Poisson_PredictBounds(SafetyAE$lData$dfTransformed, c(-5, 5))
  expect_silent(Visualize_Scatter(SafetyAE$lData$dfFlagged, dfBounds))
})

test_that("Chart has [ text ] aesthetic", {
  dfInput <- AE_Map_Adam(dfs = list(dfADSL = dfADSL, dfADAE = dfADAE))
  assessment <- AE_Assess(dfInput)
  dfBounds <- Analyze_Poisson_PredictBounds(assessment$lData$dfTransformed, c(-5, 5))
  chart <- Visualize_Scatter(assessment$lData$dfFlagged, dfBounds)
  expect_true("text" %in% names(chart$mapping))
})
