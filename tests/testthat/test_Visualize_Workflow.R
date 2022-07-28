source(testthat::test_path("testdata/data.R"))

lData <- list(
  dfSUBJ = dfSUBJ,
  dfAE = dfAE,
  dfPD = dfPD,
  dfCONSENT = dfCONSENT,
  dfIE = dfIE,
  dfDISP = dfDISP
)

study <- Study_Assess(lData = lData, bQuiet = TRUE)

test_that("flowchart is created for all assessments", {
  expect_true("flowchart" %in% names(study$ae$lChecks))
  expect_true("flowchart" %in% names(study$consent$lChecks))
  expect_true("flowchart" %in% names(study$ie$lChecks))
  expect_true("flowchart" %in% names(study$importantpd$lChecks))
  expect_true("flowchart" %in% names(study$pd$lChecks))
  expect_true("flowchart" %in% names(study$sae$lChecks))


  expect_type(study$ae$lChecks$flowchart, "list")
  expect_type(study$consent$lChecks$flowchart, "list")
  expect_type(study$ie$lChecks$flowchart, "list")
  expect_type(study$importantpd$lChecks$flowchart, "list")
  expect_type(study$pd$lChecks$flowchart, "list")
  expect_type(study$sae$lChecks$flowchart, "list")


})


