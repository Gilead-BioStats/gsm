suppressWarnings(

consent_input <- Consent_Map_Raw(
  dfConsent = clindata::raw_consent,
  dfRDSL = clindata::rawplus_rdsl,
  strConsentReason = NULL
)

)

suppressWarnings(

ie_input <- IE_Map_Raw(
  clindata::raw_ie_all ,
  clindata::rawplus_rdsl,
  strCategoryCol = 'IECAT_STD',
  vCategoryValues= c("EXCL","INCL"),
  strResultCol = 'IEORRES',
  vExpectedResultValues=c(0,1)
)

)


test_that("output is produced with consent data", {
consent_assess <- Consent_Assess(consent_input, bDataList=TRUE)

expect_silent(
  Visualize_Count(consent_assess$dfAnalyzed)
)
})

test_that("output is produced with IE data", {
  ie_assess <- IE_Assess(ie_input, bDataList=TRUE)

  expect_silent(
    Visualize_Count(ie_assess$dfAnalyzed)
  )
})

test_that("incorrect inputs throw errors",{
  consent_assess <- Consent_Assess(consent_input, bDataList=TRUE)
  ie_assess <- IE_Assess(ie_input, bDataList=TRUE)

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


