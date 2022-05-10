source(testthat::test_path("testdata/data.R"))

ieInput <- IE_Map_Raw(dfs = list(dfIE = dfIE, dfSUBJ = dfSUBJ))

# output is created as expected -------------------------------------------
test_that("output is created as expected", {
    ieAssessment <- IE_Assess(ieInput)
    expect_true(is.list(ieAssessment))
    expect_equal(names(ieAssessment),c("strFunctionName", "lParams", "lTags", "dfInput", "dfTransformed", "dfAnalyzed", "dfFlagged", "dfSummary", "chart"))
    expect_true("data.frame" %in% class(ieAssessment$dfInput))
    expect_true("data.frame" %in% class(ieAssessment$dfTransformed))
    expect_true("data.frame" %in% class(ieAssessment$dfAnalyzed))
    expect_true("data.frame" %in% class(ieAssessment$dfFlagged))
    expect_true("data.frame" %in% class(ieAssessment$dfSummary))
    expect_type(ieAssessment$strFunctionName, "character")
    expect_type(ieAssessment$lParams, "list")
    expect_type(ieAssessment$lTags, "list")
})

# metadata is returned as expected ----------------------------------------
test_that("metadata is returned as expected", {
  ieAssessment <- IE_Assess(ieInput, nThreshold = 0.755555)
  expect_equal("IE_Assess()", ieAssessment$strFunctionName)
  expect_equal("0.755555", ieAssessment$lParams$nThreshold)
  expect_equal("IE", ieAssessment$lTags$Assessment)
  expect_true("ggplot" %in% class(ieAssessment$chart))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors",{
  expect_error(IE_Assess(list()))
  expect_error(IE_Assess("Hi"))
  expect_error(IE_Assess(ieInput, nThreshold=FALSE))
  expect_error(IE_Assess(ieInput, nThreshold="A"))
  expect_error(IE_Assess(ieInput, nThreshold=c(1,2)))
  expect_error(IE_Assess(ieInput %>% select(-SubjectID)))
  expect_error(IE_Assess(ieInput %>% select(-SiteID)))
  expect_error(IE_Assess(ieInput %>% select(-Count)))
})

# incorrect lTags throw errors --------------------------------------------
test_that("incorrect lTags throw errors",{
    expect_error(IE_Assess(ieInput, lTags="hi mom"))
    expect_error(IE_Assess(ieInput, lTags=list("hi","mom")))
    expect_error(IE_Assess(ieInput, lTags=list(greeting="hi","mom")))
    expect_silent(IE_Assess(ieInput, lTags=list(greeting="hi",person="mom")))
    expect_snapshot_error(IE_Assess(ieInput, lTags = list(SiteID = "")))
    expect_snapshot_error(IE_Assess(ieInput, lTags = list(N = "")))
    expect_snapshot_error(IE_Assess(ieInput, lTags = list(Score = "")))
    expect_snapshot_error(IE_Assess(ieInput, lTags = list(Flag = "")))
})

# custom tests ------------------------------------------------------------
test_that('dfAnalyzed has appropriate model output regardless of statistical method', {
    assessment <- IE_Assess(ieInput)
    expect_true(all(c('Estimate') %in% names(assessment$dfAnalyzed)))
})

test_that("bQuiet works as intended", {
  expect_message(
    IE_Assess(ieInput, bQuiet = FALSE)
  )
})

test_that("bReturnChecks works as intended", {
  expect_true(
    'lChecks' %in% names(IE_Assess(ieInput, bReturnChecks = TRUE))
  )
})
