source(testthat::test_path("testdata/data.R"))

pd <- RunQTL("qtl0004", lData = lData)
disp <- RunQTL("qtl0006", lData = lData)

test_that("output is returned as expected", {
  expect_equal(1, nrow(pd$lResults$lData$dfSummary))
  expect_equal(1, nrow(disp$lResults$lData$dfSummary))
  expect_equal(pd$name, "qtl0004")
  expect_equal(disp$name, "qtl0006")
  expect_true(pd$bStatus)
  expect_true(disp$bStatus)
})

test_that("correct errors shown when specifying workflows", {
  lWorkflow <- MakeWorkflowList(strNames = "qtl0004", bRecursive = TRUE)

  expect_error(RunQTL("wronginput"))
  expect_error(RunQTL())
})
