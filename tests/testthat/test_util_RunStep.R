source(testthat::test_path("testdata/data.R"))

lStep <- MakeWorkflowList()

lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))

lData <- list(
  dfSUBJ = dfSUBJ,
  dfAE = dfAE,
  dfPD = dfPD,
  dfCONSENT = dfCONSENT,
  dfIE = dfIE
)

# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  ae_step <- RunStep(lStep = lStep$kri0001$steps[[2]], lMapping = lMapping, lData = lData, bQuiet = T)

  expect_type(ae_step, "list")
  expect_true(ae_step$lChecks$status)
  expect_true("data.frame" %in% class(ae_step$df))
  expect_equal(names(ae_step), c("df", "lChecks"))
  expect_snapshot(names(ae_step$df))
  expect_snapshot(names(ae_step$lChecks))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors", {
  expect_error(RunStep(lStep = "step", lMapping = lMapping, lData = lData, bQuiet = T))
  expect_error(RunStep(lStep = lStep$kri0001$steps[[2]], lMapping = 1, lData = lData, bQuiet = T))
  expect_error(RunStep(lStep = lStep$kri0001$steps[[2]], lMapping = lMapping, lData = "data", bQuiet = T))
  expect_error(RunStep(lStep = lStep$kri0001$steps[[2]], lMapping = lMapping, lData = lData, bQuiet = "false"))
})
