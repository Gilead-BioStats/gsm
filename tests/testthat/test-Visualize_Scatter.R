test_that("Output is produced", {

  # poisson model
  dfInput <- AE_Map_Adam(safetyData::adam_adsl, safetyData::adam_adae )
  SafetyAE <- AE_Assess(dfInput, strMethod = "poisson")
  dfBounds <- Analyze_Poisson_PredictBounds(SafetyAE$dfTransformed, c(-5,5))
  expect_silent(Visualize_Scatter(SafetyAE$dfFlagged, dfBounds))


  # wilcoxon model
  dfInput <- AE_Map_Adam(safetyData::adam_adsl, safetyData::adam_adae )
  SafetyAE <- AE_Assess(dfInput, strMethod="wilcoxon")
  Visualize_Scatter(SafetyAE$dfFlagged)
  expect_silent(Visualize_Scatter(SafetyAE$dfFlagged))

})
