source(testthat::test_path("testdata/data.R"))

assessment_list <- MakeWorkflowList(strNames = c("kri0001", "kri0002", "kri0003"))

lAssessments <- Study_Assess(
  lData = lData,
  bQuiet = TRUE,
  lAssessments = assessment_list
)

test_that("Assessment Report with all Valid assessments", {
  a <- Study_AssessmentReport(lAssessments = lAssessments)
  expect_true(is.data.frame(a$dfAllChecks))
  expect_true(is.data.frame(a$dfSummary))
  expect_equal(
    names(a$dfAllChecks) %>% sort(),
    c("assessment", "check", "cols_are_unique", "columns_have_empty_values", "columns_have_na", "domain", "has_expected_columns", "has_required_params", "is_data_frame", "mapping_is_list", "mappings_are_character", "notes", "spec_is_list", "step")
  )
  expect_equal(
    names(a$dfSummary) %>% sort(),
    c("assessment", "check", "domain", "notes", "step")
  )
})

test_that("Assessment Report with an issue in dfSUBJ", {
  lData <- list(
    dfSUBJ = dfSUBJ,
    dfAE = dfAE
  )

  lData$dfSUBJ[1, "SubjectID"] <- NA

  lAssessments <- Study_Assess(lData = lData, bQuiet = TRUE)
  a <- Study_AssessmentReport(lAssessments = lAssessments)

  expect_true(is.data.frame(a$dfAllChecks))
  expect_true(is.data.frame(a$dfSummary))
})

test_that("Assessment Report fails with wrong input", {
  expect_error(Study_AssessmentReport(lAssessments = TRUE))
  expect_error(Study_AssessmentReport(lAssessments = list()))
})

test_that("bViewReport works", {
  view_true <- Study_AssessmentReport(lAssessments = lAssessments, bViewReport = TRUE)
  expect_true("gt_tbl" %in% class(view_true))
})

test_that("correct messages show when data is not found", {
  ldata <- list(
    dfAE = dfAE,
    dfSUBJ = dfSUBJ
  )

  lAssessments <- Study_Assess(lData = ldata, bQuiet = TRUE)

  report <- Study_AssessmentReport(lAssessments)

  expect_snapshot(
    report$dfAllChecks %>%
      filter(domain == "dfPD" & step == "FilterDomain") %>%
      pull(notes)
  )

  expect_snapshot(
    report$dfAllChecks %>%
      filter(domain == "dfPD" & step == "PD_Map_Raw_Rate") %>%
      pull(notes)
  )
})
