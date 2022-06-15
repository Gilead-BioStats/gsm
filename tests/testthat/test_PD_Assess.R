source(testthat::test_path("testdata/data.R"))

assess_function <- gsm::PD_Assess
dfInput <- PD_Map_Raw(dfs = list(dfPD = dfPD, dfSUBJ = dfSUBJ))
output_spec <- yaml::read_yaml(system.file('specs', 'PD_Assess.yaml', package = 'gsm'))
output_mapping <- yaml::read_yaml(system.file('mappings', 'PD_Assess.yaml', package = 'gsm'))

# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  pdAssessment <- PD_Assess(dfInput)
  expect_true(is.list(pdAssessment))
  expect_equal(names(pdAssessment), c("strFunctionName", "lParams", "lTags", "dfInput", "dfTransformed", "dfAnalyzed", "dfFlagged", "dfSummary", "chart"))
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
  pdAssessment <- PD_Assess(dfInput, vThreshold = c(-5.1, 5.1), strMethod = "poisson")
  expect_equal("PD_Assess()", pdAssessment$strFunctionName)
  expect_equal("dfInput", pdAssessment$lParams$dfInput)
  expect_equal("-5.1", pdAssessment$lParams$vThreshold[2])
  expect_equal("5.1", pdAssessment$lParams$vThreshold[3])
  expect_equal("PD", pdAssessment$lTags$Assessment)
  expect_true("ggplot" %in% class(pdAssessment$chart))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors", {
  expect_snapshot_error(PD_Assess(list()))
  expect_snapshot_error(PD_Assess("Hi"))
  expect_snapshot_error(PD_Assess(dfInput, strLabel = 123))
  expect_snapshot_error(PD_Assess(dfInput, strMethod = "abacus"))
  expect_snapshot_error(PD_Assess(dfInput, strMethod = c("wilcoxon", "poisson")))
  expect_snapshot_error(PD_Assess(dfInput, vThreshold = "A"))
  expect_snapshot_error(PD_Assess(dfInput, vThreshold = 1))
  expect_snapshot_error(PD_Assess(dfInput %>% select(-SubjectID)))
  expect_snapshot_error(PD_Assess(dfInput %>% select(-SiteID)))
  expect_snapshot_error(PD_Assess(dfInput %>% select(-Count)))
  expect_snapshot_error(PD_Assess(dfInput %>% select(-Exposure)))
  expect_snapshot_error(PD_Assess(dfInput %>% select(-Rate)))
  expect_error(PD_Assess(dfInput, strKRILabel = c("label 1", "label 2")))
})

# incorrect lTags throw errors --------------------------------------------
test_that("incorrect lTags throw errors", {
  expect_error(PD_Assess(dfInput, vThreshold = c(-5.1, 5.1), lTags = "hi mom"))
  expect_error(PD_Assess(dfInput, vThreshold = c(-5.1, 5.1), lTags = list("hi", "mom")))
  expect_error(PD_Assess(dfInput, vThreshold = c(-5.1, 5.1), lTags = list(greeting = "hi", "mom")))
  expect_silent(
    PD_Assess(
      dfInput,
      vThreshold = c(-5.1, 5.1),
      lTags = list(
        greeting = "hi",
        person = "mom"
      )
    )
  )
  expect_error(PD_Assess(dfInput, lTags = list(SiteID = "")))
  expect_error(PD_Assess(dfInput, lTags = list(N = "")))
  expect_error(PD_Assess(dfInput, lTags = list(Score = "")))
  expect_error(PD_Assess(dfInput, lTags = list(Flag = "")))
})

# custom tests ------------------------------------------------------------
test_that("strMethod = 'wilcoxon' does not throw error", {
  expect_error(PD_Assess(dfInput, strMethod = "wilcoxon"), NA)
})

test_that("NA in dfInput$Count results in Error for PD_Assess", {
  pdInputNA <- dfInput
  pdInputNA[1, "Count"] <- NA
  expect_snapshot(PD_Assess(pdInputNA))
})

test_that("dfAnalyzed has appropriate model output regardless of statistical method", {
  assessmentPoisson <- PD_Assess(dfInput, strMethod = "poisson")
  expect_true(all(c("KRI", "KRILabel", "Score", "ScoreLabel") %in% names(assessmentPoisson$dfAnalyzed)))
  assessmentWilcoxon <- PD_Assess(dfInput, strMethod = "wilcoxon")
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
  pd <- PD_Assess(dfInput, strKRILabel = "my test label")
  expect_equal(unique(pd$dfSummary$KRILabel), "my test label")
})
