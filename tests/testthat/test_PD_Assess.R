source(testthat::test_path("testdata/data.R"))

pdInput <- suppressWarnings(PD_Map_Raw(dfPD, dfRDSL))

# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  pdAssessment <- PD_Assess(pdInput)
  expect_true(is.list(pdAssessment))
  expect_equal(names(pdAssessment),c("strFunctionName", "lParams","lTags", "dfInput", "dfTransformed", "dfAnalyzed", "dfFlagged", "dfSummary"))
  expect_true("data.frame" %in% class(pdAssessment$dfInput))
  expect_true("data.frame" %in% class(pdAssessment$dfTransformed))
  expect_true("data.frame" %in% class(pdAssessment$dfAnalyzed))
  expect_true("data.frame" %in% class(pdAssessment$dfFlagged))
  expect_true("data.frame" %in% class(pdAssessment$dfSummary))
  expect_type(pdAssessment$strFunctionName, "character")
  expect_type(pdAssessment$lParams, "list")
  expect_type(pdAssessment$lTags, "list")
})

# metadata is returned as expected ----------------------------------------
test_that("metadata is returned as expected", {
  pdAssessment <- PD_Assess(pdInput, vThreshold = c(-5,5), strMethod = "poisson")
  expect_equal("PD_Assess()", pdAssessment$strFunctionName)
  expect_equal("-5", pdAssessment$lParams$vThreshold[2])
  expect_equal("5", pdAssessment$lParams$vThreshold[3])
  expect_equal("PD", pdAssessment$lTags$Assessment)
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors",{
  expect_snapshot_error(PD_Assess(list()))
  expect_snapshot_error(PD_Assess("Hi"))
  expect_snapshot_error(PD_Assess(pdInput, strLabel=123))
  expect_snapshot_error(PD_Assess(pdInput, strMethod="abacus"))
  expect_snapshot_error(PD_Assess(pdInput, strMethod=c("wilcoxon", "poisson")))
  expect_snapshot_error(PD_Assess(pdInput, vThreshold = "A"))
  expect_snapshot_error(PD_Assess(pdInput, vThreshold = 1))
  expect_snapshot_error(PD_Assess(pdInput %>% select(-SubjectID)))
  expect_snapshot_error(PD_Assess(pdInput %>% select(-SiteID)))
  expect_snapshot_error(PD_Assess(pdInput %>% select(-Count)))
  expect_snapshot_error(PD_Assess(pdInput %>% select(-Exposure)))
  expect_snapshot_error(PD_Assess(pdInput %>% select(-Rate)))
})

# incorrect lTags throw errors --------------------------------------------
test_that("incorrect lTags throw errors",{
  expect_error(PD_Assess(pdInput, vThreshold = c(-5.1, 5.1), lTags="hi mom"))
  expect_error(PD_Assess(pdInput, vThreshold = c(-5.1, 5.1), lTags=list("hi","mom")))
  expect_error(PD_Assess(pdInput, vThreshold = c(-5.1, 5.1), lTags=list(greeting = "hi", "mom")))
  expect_silent(PD_Assess(pdInput, vThreshold = c(-5.1, 5.1), lTags=list(greeting = "hi", person = "mom")))
  expect_error(PD_Assess(pdInput, lTags = list(SiteID = "")))
  expect_error(PD_Assess(pdInput, lTags = list(N = "")))
  expect_error(PD_Assess(pdInput, lTags = list(Score = "")))
  expect_error(PD_Assess(pdInput, lTags = list(Flag = "")))
})

# custom tests ------------------------------------------------------------
test_that("strMethod = 'wilcoxon' does not throw error",{
  expect_silent(PD_Assess(pdInput, strMethod = "wilcoxon"))
})

test_that("NA in dfInput$Count results in Error for PD_Assess",{
  pdInputNA <- pdInput
  pdInputNA[1,"Count"] <- NA
  expect_snapshot_error(PD_Assess(pdInputNA))
})


