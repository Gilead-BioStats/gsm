source(testthat::test_path("testdata/data.R"))

lData <- list(
  dfSUBJ = dfSUBJ,
  dfAE = dfAE,
  dfPD = dfPD,
  dfCONSENT = dfCONSENT,
  dfIE = dfIE,
  dfDISP = dfDISP
)

lAssessments <- Study_Assess(lData = lData, bQuiet = TRUE)

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
    dfAE = dfAE,
    dfIE = dfIE
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

  expect_equal(
    report$dfAllChecks %>% filter(domain == "dfCONSENT") %>% pull(notes),
    "Data not found for consent assessment"
  )

  expect_equal(
    report$dfAllChecks %>% filter(domain == "dfIE") %>% pull(notes),
    "Data not found for ie assessment"
  )

  expect_equal(
    report$dfAllChecks %>% filter(domain == "dfPD" & step == "FilterDomain") %>% pull(notes),
    "Data not found for importantpd assessment"
  )

  expect_equal(
    report$dfAllChecks %>% filter(assessment == "pd" & domain == "dfPD" & step == "PD_Map_Raw") %>% pull(notes),
    "Data not found for pd assessment"
  )
})
