source(testthat::test_path("testdata/data.R"))

test_that("Output is produced", {
  # poisson model
  dfInput <- AE_Map_Adam(dfs = list(dfADSL = dfADSL, dfADAE = dfADAE))
  SafetyAE <- AE_Assess(dfInput, strMethod = "poisson")
  dfBounds <- Analyze_Poisson_PredictBounds(SafetyAE$dfTransformed, c(-5, 5))
  expect_silent(Visualize_Scatter(SafetyAE$dfFlagged, dfBounds))


  # wilcoxon model
  dfInput <- AE_Map_Adam(dfs = list(dfADSL = dfADSL, dfADAE = dfADAE))
  SafetyAE <- AE_Assess(dfInput, strMethod = "wilcoxon")
  Visualize_Scatter(SafetyAE$dfFlagged)
  expect_silent(Visualize_Scatter(SafetyAE$dfFlagged))
})

test_that("Chart has [ text ] aesthetic", {
  dfInput <- AE_Map_Adam(dfs = list(dfADSL = dfADSL, dfADAE = dfADAE))
  assessment <- AE_Assess(dfInput)
  dfBounds <- Analyze_Poisson_PredictBounds(assessment$dfTransformed, c(-5, 5))
  chart <- Visualize_Scatter(assessment$dfFlagged, dfBounds)
  expect_true("text" %in% names(chart$mapping))
})
