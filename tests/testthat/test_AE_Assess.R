source(testthat::test_path("testdata/data.R"))

assess_function <- gsm::AE_Assess
dfInput <- AE_Map_Raw(dfs = list(dfAE = dfAE, dfSUBJ = dfSUBJ))
output_spec <- yaml::read_yaml(paste0(here::here(), '/inst/specs/AE_Assess.yaml'))
output_mapping <- yaml::read_yaml(paste0(here::here(), '/inst/mappings/AE_Assess.yaml'))

# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  aeAssessment <- AE_Assess(dfInput, vThreshold = c(-5.1, 5.1))
  expect_true(is.list(aeAssessment))
  expect_equal(names(aeAssessment), c("strFunctionName", "lParams", "lTags", "dfInput", "dfTransformed", "dfAnalyzed", "dfFlagged", "dfSummary", "chart"))
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
  aeAssessment <- AE_Assess(dfInput, vThreshold = c(-5.1, 5.1))
  expect_equal("AE_Assess()", aeAssessment$strFunctionName)
  expect_equal("dfInput", aeAssessment$lParams$dfInput)
  expect_equal("-5.1", aeAssessment$lParams$vThreshold[2])
  expect_equal("5.1", aeAssessment$lParams$vThreshold[3])
  expect_equal("AE", aeAssessment$lTags$Assessment)
  expect_true("ggplot" %in% class(aeAssessment$chart))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors", {
  expect_snapshot_error(AE_Assess(list()))
  expect_snapshot_error(AE_Assess("Hi"))
  expect_snapshot_error(AE_Assess(dfInput, strMethod = 123))
  expect_snapshot_error(AE_Assess(dfInput, strMethod = "abacus"))
  expect_snapshot_error(AE_Assess(dfInput, strMethod = c("wilcoxon", "poisson")))
  expect_snapshot_error(AE_Assess(dfInput, vThreshold = "A"))
  expect_snapshot_error(AE_Assess(dfInput, vThreshold = 1))
  expect_snapshot_error(AE_Assess(dfInput %>% select(-SubjectID)))
  expect_snapshot_error(AE_Assess(dfInput %>% select(-SiteID)))
  expect_snapshot_error(AE_Assess(dfInput %>% select(-Count)))
  expect_snapshot_error(AE_Assess(dfInput %>% select(-Exposure)))
  expect_snapshot_error(AE_Assess(dfInput %>% select(-Rate)))
  expect_error(AE_Assess(dfInput, strKRILabel = c("label 1", "label 2")))
})

# incorrect lTags throw errors --------------------------------------------
test_that("incorrect lTags throw errors", {
  expect_snapshot_error(AE_Assess(dfInput, vThreshold = c(-5.1, 5.1), lTags = "hi mom"))
  expect_snapshot_error(AE_Assess(dfInput, vThreshold = c(-5.1, 5.1), lTags = list("hi", "mom")))
  expect_snapshot_error(AE_Assess(dfInput, vThreshold = c(-5.1, 5.1), lTags = list(greeting = "hi", "mom")))
  expect_silent(
    AE_Assess(
      dfInput,
      vThreshold = c(-5.1, 5.1),
      lTags = list(
        greeting = "hi",
        person = "mom"
      )
    )
  )
  expect_snapshot_error(AE_Assess(dfInput, lTags = list(SiteID = "")))
  expect_snapshot_error(AE_Assess(dfInput, lTags = list(N = "")))
  expect_snapshot_error(AE_Assess(dfInput, lTags = list(Score = "")))
  expect_snapshot_error(AE_Assess(dfInput, lTags = list(Flag = "")))
})

# custom tests ------------------------------------------------------------
test_that("strMethod = 'wilcoxon' does not throw error", {
  expect_error(AE_Assess(dfInput, strMethod = "wilcoxon"), NA)
})

test_that("NA in dfInput$Count results in Error for AE_Assess", {
  aeInputNA <- dfInput
  aeInputNA[1, "Count"] <- NA
  expect_snapshot(AE_Assess(aeInputNA))
})

test_that("dfAnalyzed has appropriate model output regardless of statistical method", {
  assessmentPoisson <- AE_Assess(dfInput, strMethod = "poisson")
  expect_true(all(c("KRI", "KRILabel", "Score", "ScoreLabel") %in% names(assessmentPoisson$dfAnalyzed)))
  assessmentWilcoxon <- AE_Assess(dfInput, strMethod = "wilcoxon")
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
  ae <- AE_Assess(dfInput, strKRILabel = "my test label")
  expect_equal(unique(ae$dfSummary$KRILabel), "my test label")
})
