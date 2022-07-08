source(testthat::test_path("testdata/data.R"))

assess_function <- gsm::IE_Assess
dfInput <- IE_Map_Raw(dfs = list(dfIE = dfIE, dfSUBJ = dfSUBJ))
output_spec <- yaml::read_yaml(system.file("specs", "IE_Assess.yaml", package = "gsm"))
output_mapping <- yaml::read_yaml(system.file("mappings", "IE_Assess.yaml", package = "gsm"))

# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  assessment <- assess_function(dfInput)
  expect_true(is.list(assessment))
  expect_equal(names(assessment), c("strFunctionName", "lParams", "lTags", "dfInput", "dfTransformed", "dfAnalyzed", "dfFlagged", "dfSummary", "chart"))
  expect_true("data.frame" %in% class(assessment$dfInput))
  expect_true("data.frame" %in% class(assessment$dfTransformed))
  expect_true("data.frame" %in% class(assessment$dfAnalyzed))
  expect_true("data.frame" %in% class(assessment$dfFlagged))
  expect_true("data.frame" %in% class(assessment$dfSummary))
  expect_type(assessment$strFunctionName, "character")
  expect_type(assessment$lParams, "list")
  expect_type(assessment$lTags, "list")
})

# metadata is returned as expected ----------------------------------------
test_that("metadata is returned as expected", {
  assessment <- assess_function(dfInput, nThreshold = 0.755555)
  expect_equal("assess_function()", assessment$strFunctionName)
  expect_equal("0.755555", assessment$lParams$nThreshold)
  expect_equal("IE", assessment$lTags$Assessment)
  expect_true("ggplot" %in% class(assessment$chart))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors", {
  expect_error(assess_function(list()))
  expect_error(assess_function("Hi"))
  expect_error(assess_function(dfInput, nThreshold = FALSE))
  expect_error(assess_function(dfInput, nThreshold = "A"))
  expect_error(assess_function(dfInput, nThreshold = c(1, 2)))
  expect_error(assess_function(dfInput %>% select(-SubjectID)))
  expect_error(assess_function(dfInput %>% select(-GroupID)))
  expect_error(assess_function(dfInput %>% select(-Count)))
  expect_error(assess_function(dfInput, strKRILabel = c("label 1", "label 2")))
})

# incorrect lTags throw errors --------------------------------------------
test_that("incorrect lTags throw errors", {
  expect_error(assess_function(dfInput, lTags = "hi mom"))
  expect_error(assess_function(dfInput, lTags = list("hi", "mom")))
  expect_error(assess_function(dfInput, lTags = list(greeting = "hi", "mom")))
  expect_silent(assess_function(dfInput, lTags = list(greeting = "hi", person = "mom")))
  expect_snapshot_error(assess_function(dfInput, lTags = list(GroupID = "")))
  expect_snapshot_error(assess_function(dfInput, lTags = list(N = "")))
  expect_snapshot_error(assess_function(dfInput, lTags = list(Score = "")))
  expect_snapshot_error(assess_function(dfInput, lTags = list(Flag = "")))
  expect_snapshot_error(assess_function(dfInput, lTags = list(KRI = "")))
  expect_snapshot_error(assess_function(dfInput, lTags = list(KRILabel = "")))
})

# custom tests ------------------------------------------------------------
test_that("dfAnalyzed has appropriate model output regardless of statistical method", {
  assessment <- assess_function(dfInput)
  expect_equal(unique(assessment$dfAnalyzed$ScoreLabel), "# of Inclusion/Exclusion Issues")
  expect_equal(sort(assessment$dfAnalyzed$Score), sort(assessment$dfSummary$Score))
})

test_that("bQuiet and bReturnChecks work as intended", {
  test_logical_assess_parameters(assess_function, dfInput)
})

test_that("strKRILabel works as intended", {
  assessment <- assess_function(dfInput, strKRILabel = "my test label")
  expect_equal(unique(assessment$dfSummary$KRILabel), "my test label")
})
