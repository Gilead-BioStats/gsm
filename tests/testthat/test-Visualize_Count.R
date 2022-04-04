source(testthat::test_path("testdata/data.R"))

consentInput <- Consent_Map_Raw(dfConsent, dfRDSL)
ieInput <- IE_Map_Raw(dfIE, dfRDSL)

test_that("output is produced with consent data", {
consent_assess <- Consent_Assess(consentInput)
expect_silent(Visualize_Count(consent_assess$dfAnalyzed))
})

test_that("output is produced with IE data", {
  ie_assess <- IE_Assess(ieInput)
  expect_silent(Visualize_Count(ie_assess$dfAnalyzed))
})

test_that("incorrect inputs throw errors",{
  consent_assess <- Consent_Assess(consentInput)
  ie_assess <- IE_Assess(ieInput)
  expect_error(Visualize_Count(list()))
  expect_error(Visualize_Count("Hi"))
  expect_error(Visualize_Count(consent_assess$dfAnalyzed, strTotalCol = "not here"))
  expect_error(Visualize_Count(consent_assess$dfAnalyzed, strTotalCol = 1))
  expect_error(Visualize_Count(consent_assess$dfAnalyzed, strCountCol = "not here"))
  expect_error(Visualize_Count(consent_assess$dfAnalyzed, strCountCol = 1))
  expect_error(Visualize_Count(consent_assess$dfAnalyzed, strFlagCol = "no"))
  expect_error(Visualize_Count(consent_assess$dfAnalyzed, strFlagCol = 1))
  expect_error(Visualize_Count(consent_assess$dfAnalyzed, strTitle = list()))
})


