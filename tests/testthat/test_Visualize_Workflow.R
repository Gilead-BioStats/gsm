source(testthat::test_path("testdata/data.R"))
load(testthat::test_path("testdata/StudyStandard.RData"))

lData <- list(
  dfSUBJ = dfSUBJ,
  dfAE = dfAE,
  dfPD = dfPD,
  dfCONSENT = dfCONSENT,
  dfIE = dfIE,
  dfSDRGCOMP = dfSDRGCOMP,
  dfSTUDCOMP = dfSTUDCOMP
)

test_that("flowchart is created for all assessments", {
  expect_true("flowchart" %in% names(StudyStandard$kri0001$lChecks))
  expect_true("flowchart" %in% names(StudyStandard$kri0002$lChecks))
  expect_true("flowchart" %in% names(StudyStandard$kri0003$lChecks))
  expect_true("flowchart" %in% names(StudyStandard$kri0004$lChecks))
  expect_true("flowchart" %in% names(StudyStandard$kri0005$lChecks))
  expect_true("flowchart" %in% names(StudyStandard$kri0006$lChecks))
  expect_true("flowchart" %in% names(StudyStandard$kri0007$lChecks))

  expect_type(StudyStandard$kri0001$lChecks$flowchart, "list")
  expect_type(StudyStandard$kri0002$lChecks$flowchart, "list")
  expect_type(StudyStandard$kri0003$lChecks$flowchart, "list")
  expect_type(StudyStandard$kri0004$lChecks$flowchart, "list")
  expect_type(StudyStandard$kri0005$lChecks$flowchart, "list")
  expect_type(StudyStandard$kri0006$lChecks$flowchart, "list")
  expect_type(StudyStandard$kri0007$lChecks$flowchart, "list")
})
