source(testthat::test_path("testdata/data.R"))

lData <- list(
  dfSUBJ = dfSUBJ,
  dfAE = dfAE,
  dfPD = dfPD,
  dfCONSENT = dfCONSENT,
  dfIE = dfIE,
  dfSDRGCOMP = dfSDRGCOMP,
  dfSTUDCOMP = dfSTUDCOMP
)

study <- Study_Assess(lData = lData, bQuiet = TRUE) %>%
  suppressWarnings()

test_that("flowchart is created for all assessments", {
  expect_true("flowchart" %in% names(study$kri0001$lChecks))
  expect_true("flowchart" %in% names(study$kri0002$lChecks))
  expect_true("flowchart" %in% names(study$kri0003$lChecks))
  expect_true("flowchart" %in% names(study$kri0004$lChecks))
  expect_true("flowchart" %in% names(study$kri0005$lChecks))
  expect_true("flowchart" %in% names(study$kri0006$lChecks))
  expect_true("flowchart" %in% names(study$kri0007$lChecks))
  expect_true("flowchart" %in% names(study$kri0008$lChecks))

  expect_type(study$kri0001$lChecks$flowchart, "list")
  expect_type(study$kri0002$lChecks$flowchart, "list")
  expect_type(study$kri0003$lChecks$flowchart, "list")
  expect_type(study$kri0004$lChecks$flowchart, "list")
  expect_type(study$kri0005$lChecks$flowchart, "list")
  expect_type(study$kri0006$lChecks$flowchart, "list")
  expect_type(study$kri0007$lChecks$flowchart, "list")
  expect_type(study$kri0008$lChecks$flowchart, "list")

})
