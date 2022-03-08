test_that("Output is produced", {
  dfInput <- AE_Map_Adam( safetyData::adam_adsl, safetyData::adam_adae )
  SafetyAE <- AE_Assess( dfInput , bDataList=TRUE, strMethod = "wilcoxon")
  dfBounds <- Analyze_Poisson_PredictBounds(SafetyAE$dfTransformed, c(-5,5))

  expect_silent(Visualize_Poisson(SafetyAE$dfFlagged, dfBounds))
})
