source(testthat::test_path("testdata/data.R"))

aeInput <- AE_Map_Raw(dfAE, dfSubj)

# output is created as expected -------------------------------------------
test_that("output is created as expected",{
    aeAssessment <- AE_Assess(aeInput, vThreshold = c(-5.1, 5.1))
    expect_true(is.list(aeAssessment))
    expect_equal(names(aeAssessment),c("strFunctionName", "lParams", "lTags", "dfInput", "dfTransformed", "dfAnalyzed", "dfFlagged", "dfSummary"))
    expect_true("data.frame" %in% class(aeAssessment$dfInput))
    expect_true("data.frame" %in% class(aeAssessment$dfTransformed))
    expect_true("data.frame" %in% class(aeAssessment$dfAnalyzed))
    expect_true("data.frame" %in% class(aeAssessment$dfFlagged))
    expect_true("data.frame" %in% class(aeAssessment$dfSummary))
    expect_type(aeAssessment$strFunctionName, "character")
    expect_type(aeAssessment$lParams, "list")
    expect_type(aeAssessment$lTags, "list")
})

# metadata is returned as expected ----------------------------------------
test_that("metadata is returned as expected", {
    aeAssessment <- AE_Assess(aeInput, vThreshold = c(-5.1, 5.1))
    expect_equal("AE_Assess()", aeAssessment$strFunctionName)
    expect_equal("aeInput", aeAssessment$lParams$dfInput)
    expect_equal("-5.1", aeAssessment$lParams$vThreshold[2])
    expect_equal("5.1", aeAssessment$lParams$vThreshold[3])
    expect_equal("AE", aeAssessment$lTags$Assessment)
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors",{
    expect_snapshot_error(AE_Assess(list()))
    expect_snapshot_error(AE_Assess("Hi"))
    expect_snapshot_error(AE_Assess(aeInput, strMethod=123))
    expect_snapshot_error(AE_Assess(aeInput, strMethod="abacus"))
    expect_snapshot_error(AE_Assess(aeInput, strMethod=c("wilcoxon", "poisson")))
    expect_snapshot_error(AE_Assess(aeInput %>% select(-SubjectID)))
    expect_snapshot_error(AE_Assess(aeInput %>% select(-SiteID)))
    expect_snapshot_error(AE_Assess(aeInput %>% select(-Count)))
    expect_snapshot_error(AE_Assess(aeInput %>% select(-Exposure)))
    expect_snapshot_error(AE_Assess(aeInput %>% select(-Rate)))
})

# incorrect lTags throw errors --------------------------------------------
test_that("incorrect lTags throw errors",{
    expect_snapshot_error(AE_Assess(aeInput, vThreshold = c(-5.1, 5.1), lTags="hi mom"))
    expect_snapshot_error(AE_Assess(aeInput, vThreshold = c(-5.1, 5.1), lTags=list("hi","mom")))
    expect_snapshot_error(AE_Assess(aeInput, vThreshold = c(-5.1, 5.1), lTags=list(greeting = "hi", "mom")))
    expect_silent(AE_Assess(aeInput, vThreshold = c(-5.1, 5.1), lTags=list(greeting = "hi", person = "mom")))
    expect_snapshot_error(AE_Assess(aeInput, lTags = list(SiteID = "")))
    expect_snapshot_error(AE_Assess(aeInput, lTags = list(N = "")))
    expect_snapshot_error(AE_Assess(aeInput, lTags = list(Score = "")))
    expect_snapshot_error(AE_Assess(aeInput, lTags = list(Flag = "")))
})

# custom tests ------------------------------------------------------------


