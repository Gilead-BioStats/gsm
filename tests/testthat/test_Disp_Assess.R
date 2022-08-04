source(testthat::test_path("testdata/data.R"))

assess_function <- gsm::Disp_Assess
dfInput <- Disp_Map_Raw(dfs = list(dfDISP = dfDISP, dfSUBJ = dfSUBJ))
output_spec <- yaml::read_yaml(system.file("specs", "Disp_Assess.yaml", package = "gsm"))
output_mapping <- yaml::read_yaml(system.file("mappings", "Disp_Assess.yaml", package = "gsm"))

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
  assessment <- assess_function(dfInput)
  expect_equal("assess_function()", assessment$strFunctionName)
  expect_equal("dfInput", assessment$lParams$dfInput)
  expect_equal("Disposition", assessment$lTags$Assessment)
  expect_true("ggplot" %in% class(assessment$chart))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors", {
  expect_snapshot_error(assess_function(list()))
  expect_snapshot_error(assess_function("Hi"))
  expect_snapshot_error(assess_function(dfInput, strMethod = 123))
  expect_snapshot_error(assess_function(dfInput, strMethod = "abacus"))
  expect_snapshot_error(assess_function(dfInput, strMethod = c("wilcoxon", "poisson")))
  expect_snapshot_error(assess_function(dfInput, vThreshold = "A"))
  expect_snapshot_error(assess_function(dfInput, vThreshold = 1))
  expect_snapshot_error(assess_function(dfInput %>% select(-SubjectID)))
  expect_snapshot_error(assess_function(dfInput %>% select(-SiteID)))
  expect_snapshot_error(assess_function(dfInput %>% select(-Count)))
  expect_error(assess_function(dfInput, strKRILabel = c("label 1", "label 2")))
})

# incorrect lTags throw errors --------------------------------------------
test_that("incorrect lTags throw errors", {
  expect_snapshot_error(assess_function(dfInput, lTags = "hi mom"))
  expect_snapshot_error(assess_function(dfInput, lTags = list("hi", "mom")))
  expect_snapshot_error(assess_function(dfInput, lTags = list(greeting = "hi", "mom")))
  expect_silent(
    assess_function(
      dfInput,
      lTags = list(
        greeting = "hi",
        person = "mom"
      )
    )
  )
  expect_snapshot_error(assess_function(dfInput, lTags = list(GroupID = "")))
  expect_snapshot_error(assess_function(dfInput, lTags = list(GroupLabel = "")))
  expect_snapshot_error(assess_function(dfInput, lTags = list(N = "")))
  expect_snapshot_error(assess_function(dfInput, lTags = list(KRI = "")))
  expect_snapshot_error(assess_function(dfInput, lTags = list(KRILabel = "")))
  expect_snapshot_error(assess_function(dfInput, lTags = list(Score = "")))
  expect_snapshot_error(assess_function(dfInput, lTags = list(ScoreLabel = "")))
  expect_snapshot_error(assess_function(dfInput, lTags = list(Flag = "")))
})

# custom tests ------------------------------------------------------------
test_that("strMethod = 'fisher' does not throw error", {
  expect_error(assess_function(dfInput, strMethod = "fisher"), NA)
})

test_that("strMethod = 'identity' does not throw error", {
  expect_error(assess_function(dfInput, strMethod = "identity"), NA)
})
