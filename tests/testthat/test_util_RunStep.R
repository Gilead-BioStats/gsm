source(testthat::test_path("testdata/data.R"))

lStep <- MakeAssessmentList()

lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))

lData <- list(
  dfSUBJ = dfSUBJ,
  dfAE = dfAE,
  dfPD = dfPD,
  dfCONSENT = dfCONSENT,
  dfIE = dfIE
)

lTags <- list(Study = "myStudy")

# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  ae_step <- RunStep(lStep = lStep$ae$workflow[[1]], lMapping = lMapping, lData = lData, lTags = lTags, bQuiet = T)

  expect_type(ae_step, "list")
  expect_true(ae_step$lChecks$status)
  expect_true("data.frame" %in% class(ae_step$df))
  expect_equal(names(ae_step), c("df", "lChecks"))
  expect_equal(names(ae_step$df), c("SubjectID", "AE_SERIOUS", "AE_TE_FLAG", "AE_GRADE"))
  expect_equal(names(ae_step$lChecks), c("dfAE", "status"))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors", {
  expect_error(RunStep(lStep = "step", lMapping = lMapping, lData = lData, lTags = lTags, bQuiet = T))
  expect_error(RunStep(lStep = lStep$ae$workflow[[1]], lMapping = 1, lData = lData, lTags = lTags, bQuiet = T))
  expect_error(RunStep(lStep = lStep$ae$workflow[[1]], lMapping = lMapping, lData = "data", lTags = lTags, bQuiet = T))
  expect_error(RunStep(lStep = lStep$ae$workflow[[1]], lMapping = lMapping, lData = lData, lTags = lTags, bQuiet = "false"))
})
