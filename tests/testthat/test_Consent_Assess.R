source(testthat::test_path("testdata/data.R"))

consentInput <-  Consent_Map_Raw(dfs = list(dfCONSENT = dfCONSENT, dfSUBJ = dfSUBJ))

# output is created as expected -------------------------------------------
test_that("output is created as expected",{
    consentAssessment <- Consent_Assess(consentInput)
    expect_true(is.list(consentAssessment))
    expect_equal(names(consentAssessment),c("strFunctionName", "lParams", "lTags", "dfInput", "dfTransformed", "dfAnalyzed", "dfFlagged", "dfSummary", "chart"))
    expect_true("data.frame" %in% class(consentAssessment$dfInput))
    expect_true("data.frame" %in% class(consentAssessment$dfTransformed))
    expect_true("data.frame" %in% class(consentAssessment$dfAnalyzed))
    expect_true("data.frame" %in% class(consentAssessment$dfFlagged))
    expect_true("data.frame" %in% class(consentAssessment$dfSummary))
    expect_type(consentAssessment$strFunctionName, "character")
    expect_type(consentAssessment$lParams, "list")
    expect_type(consentAssessment$lTags, "list")
})

# metadata is returned as expected ----------------------------------------
test_that("metadata is returned as expected", {
  consentAssessment <- Consent_Assess(consentInput, nThreshold = 0.6)
  expect_equal("Consent_Assess()", consentAssessment$strFunctionName)
  expect_equal("consentInput", consentAssessment$lParams$dfInput)
  expect_equal("0.6", consentAssessment$lParams$nThreshold)
  expect_equal("Consent", consentAssessment$lTags$Assessment)
  expect_true("ggplot" %in% class(consentAssessment$chart))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors",{
  expect_snapshot_error(Consent_Assess(list()))
  expect_snapshot_error(Consent_Assess("Hi"))
  expect_snapshot_error(Consent_Assess(consentInput, nThreshold = "A"))
  expect_snapshot_error(Consent_Assess(consentInput, nThreshold = c(1,2)))
  expect_snapshot_error(Consent_Assess(consentInput %>% select(-SubjectID)))
  expect_snapshot_error(Consent_Assess(consentInput %>% select(-SiteID)))
  expect_snapshot_error(Consent_Assess(consentInput %>% select(-Count)))
})



# incorrect lTags throw errors --------------------------------------------
test_that("incorrect lTags throw errors",{
  expect_snapshot_error(Consent_Assess(consentInput, lTags="hi mom"))
  expect_snapshot_error(Consent_Assess(consentInput, lTags=list("hi","mom")))
  expect_snapshot_error(Consent_Assess(consentInput, lTags=list(greeting="hi","mom")))
  expect_silent(Consent_Assess(consentInput, lTags=list(greeting="hi",person="mom")))
  expect_error(Consent_Assess(consentInput, lTags = list(SiteID = "")))
  expect_error(Consent_Assess(consentInput, lTags = list(N = "")))
  expect_error(Consent_Assess(consentInput, lTags = list(Score = "")))
  expect_error(Consent_Assess(consentInput, lTags = list(Flag = "")))
})


# custom tests ------------------------------------------------------------
test_that('dfAnalyzed has appropriate model output regardless of statistical method', {
    assessment <- Consent_Assess(consentInput)
    expect_true(all(c('Estimate') %in% names(assessment$dfAnalyzed)))
})

test_that("bQuiet works as intended", {
  expect_message(
    Consent_Assess(consentInput, bQuiet = FALSE)
  )
})

test_that("bReturnChecks works as intended", {
  expect_true(
    'lChecks' %in% names(Consent_Assess(consentInput, bReturnChecks = TRUE))
  )
})
