lData <- list(
  dfSUBJ = clindata::rawplus_dm,
  dfAE = clindata::rawplus_ae,
  dfPD = clindata::ctms_protdev,
  dfCONSENT = clindata::rawplus_consent,
  dfIE = clindata::rawplus_ie,
  dfLB = clindata::rawplus_lb,
  dfSTUDCOMP = clindata::rawplus_studcomp,
  dfSDRGCOMP = clindata::rawplus_sdrgcomp
)


lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))

lAssessments <- gsm::MakeWorkflowList()

code <- ExportCode(lData, lMapping, lAssessments)


test_that("code is consistently rendered as expected", {
  expect_snapshot(
    glue::glue_collapse(code, sep = "\n\n")
  )
})


test_that("file writes to strPath when provided", {
  dir <- tempdir()

  ExportCode(
    lData,
    lMapping,
    lAssessments,
    strPath = dir
  )

  expect_true("gsm_code.R" %in% list.files(dir))
})


test_that("file is saved with correct name when provided", {
  dir <- tempdir()

  ExportCode(
    lData,
    lMapping,
    lAssessments,
    strPath = dir,
    strFileName = "testing_file_name"
  )

  expect_true("testing_file_name.R" %in% list.files(dir))
})


## possible resource to test inserting text: https://github.com/rstudio/rstudioapi/blob/main/tests/testthat/test-document-apis.R
