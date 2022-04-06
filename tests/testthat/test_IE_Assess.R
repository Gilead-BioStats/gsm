source(testthat::test_path("testdata/data.R"))

ieInput <- IE_Map_Raw(dfIE, dfSubj)

# output is created as expected -------------------------------------------
test_that("output is created as expected", {
    ieAssessment <- IE_Assess(ieInput)
    expect_true(is.list(ieAssessment))
    expect_equal(names(ieAssessment),c("strFunctionName", "lParams", "lTags", "dfInput", "dfTransformed", "dfAnalyzed", "dfFlagged", "dfSummary"))
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
ie_input1 <- tibble::tribble(        ~SubjectID, ~SiteID, ~Count,
                                         "0142", "X194X",     9L,
                                         "0308", "X159X",     9L,
                                         "0776", "X194X",     8L,
                                         "1032", "X033X",     9L
                                     )

ie_summary <- IE_Assess(ie_input1)


target_ie_summary <- tibble::tribble(  ~SiteID, ~N, ~Score, ~Flag, ~Assessment,
                                    "X194X", 2L,      17L,    1, "IE",
                                    "X033X", 1L,      9L,     1, "IE",
                                    "X159X", 1L,      9L,     1, "IE")

target_ie_summary_NA_SiteID <- tibble::tribble(     ~SiteID, ~N, ~Score, ~Flag,~Assessment,
                                                "X033X", 1L,      9L,     1,"IE",
                                                "X159X", 1L,      9L,     1,"IE",
                                                    NA, 1L,      9L,     1,"IE",
                                                "X194X", 1L,      8L,     1,"IE")


test_that("NA in dfInput$SubjectID does not affect resulting dfSummary output for IE_Assess",{
  ie_input_in <- ie_input1; ie_input_in[1:2,"SubjectID"] = NA
  ie_summary <- IE_Assess(ie_input_in)
  expect_equal(ie_summary$dfSummary,target_ie_summary)
})

test_that("NA in dfInput$SiteID results in NA for SiteID in dfSummary output for IE_Assess",{
  ie_input_in <- ie_input1; ie_input_in[1,"SiteID"] = NA
  ie_summary <- IE_Assess(ie_input_in)
  expect_equal(ie_summary$dfSummary,target_ie_summary_NA_SiteID)
})

test_that("NA in dfInput$Count results in Error for IE_Assess",{
  ie_input_in <- ie_input1; ie_input_in[1,"Count"] = NA
  expect_error(IE_Assess(ie_input_in))
})




