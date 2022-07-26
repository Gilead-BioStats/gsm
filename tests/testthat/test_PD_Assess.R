source(testthat::test_path("testdata/data.R"))

assess_function <- gsm::PD_Assess
dfInput <- PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ))
output_spec <- yaml::read_yaml(system.file("specs", "PD_Assess.yaml", package = "gsm"))
output_mapping <- yaml::read_yaml(system.file("mappings", "PD_Assess.yaml", package = "gsm"))

# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  assessment <- assess_function(dfInput)
  expect_true(is.list(assessment))
  expect_equal(names(assessment), c("strFunctionName",
                                    "lParams",
                                    "lTags",
                                    "dfInput",
                                    "dfTransformed",
                                    "dfAnalyzed",
                                    "dfFlagged",
                                    "dfSummary",
                                    "dfBounds",
                                    "chart"))
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
  assessment <- assess_function(dfInput, vThreshold = c(-5.1, 5.1), strMethod = "poisson")
  expect_equal("assess_function()", assessment$strFunctionName)
  expect_equal("dfInput", assessment$lParams$dfInput)
  expect_equal("-5.1", assessment$lParams$vThreshold[2])
  expect_equal("5.1", assessment$lParams$vThreshold[3])
  expect_equal("PD", assessment$lTags$Assessment)
  expect_true("ggplot" %in% class(assessment$chart))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors", {
  expect_snapshot_error(assess_function(list()))
  expect_snapshot_error(assess_function("Hi"))
  expect_snapshot_error(assess_function(dfInput, strLabel = 123))
  expect_snapshot_error(assess_function(dfInput, strMethod = "abacus"))
  expect_snapshot_error(assess_function(dfInput, strMethod = c("wilcoxon", "poisson")))
  expect_snapshot_error(assess_function(dfInput, vThreshold = "A"))
  expect_snapshot_error(assess_function(dfInput, vThreshold = 1))
  expect_snapshot_error(assess_function(dfInput %>% select(-SubjectID)))
  expect_snapshot_error(assess_function(dfInput %>% select(-SiteID)))
  expect_snapshot_error(assess_function(dfInput %>% select(-Count)))
  expect_snapshot_error(assess_function(dfInput %>% select(-Exposure)))
  expect_snapshot_error(assess_function(dfInput %>% select(-Rate)))
  expect_error(assess_function(dfInput, strKRILabel = c("label 1", "label 2")))
})

# incorrect lTags throw errors --------------------------------------------
test_that("incorrect lTags throw errors", {
  expect_error(assess_function(dfInput, vThreshold = c(-5.1, 5.1), lTags = "hi mom"))
  expect_error(assess_function(dfInput, vThreshold = c(-5.1, 5.1), lTags = list("hi", "mom")))
  expect_error(assess_function(dfInput, vThreshold = c(-5.1, 5.1), lTags = list(greeting = "hi", "mom")))
  expect_silent(
    assess_function(
      dfInput,
      vThreshold = c(-5.1, 5.1),
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
test_that("strMethod = 'wilcoxon' does not throw error", {
  expect_error(assess_function(dfInput, strMethod = "wilcoxon"), NA)
})

test_that("strMethod = 'identity' does not throw error", {
  expect_error(assess_function(dfInput, strMethod = "identity"), NA)
})

test_that("NA in dfInput$Count results in Error for assess_function", {
  dfInputNA <- dfInput
  dfInputNA[1, "Count"] <- NA
  expect_snapshot(assess_function(dfInputNA))
})

test_that("dfAnalyzed has appropriate model output regardless of statistical method", {
  assessmentPoisson <- assess_function(dfInput, strMethod = "poisson")
  expect_true(all(c("KRI", "KRILabel", "Score", "ScoreLabel") %in% names(assessmentPoisson$dfAnalyzed)))
  assessmentWilcoxon <- assess_function(dfInput, strMethod = "wilcoxon")
  expect_true(all(c("KRI", "KRILabel", "Score", "ScoreLabel") %in% names(assessmentWilcoxon$dfAnalyzed)))

  expect_equal(unique(assessmentPoisson$dfAnalyzed$ScoreLabel), "Residuals")
  expect_equal(unique(assessmentWilcoxon$dfAnalyzed$ScoreLabel), "P value")

  expect_equal(sort(assessmentPoisson$dfAnalyzed$Score), sort(assessmentPoisson$dfSummary$Score))
  expect_equal(sort(assessmentWilcoxon$dfAnalyzed$Score), sort(assessmentWilcoxon$dfSummary$Score))
})

test_that("bQuiet and bReturnChecks work as intended", {
  test_logical_assess_parameters(assess_function, dfInput)
})

test_that("strKRILabel works as intended", {
  assessment <- assess_function(dfInput, strKRILabel = "my test label")
  expect_equal(unique(assessment$dfSummary$KRILabel), "my test label")
})
