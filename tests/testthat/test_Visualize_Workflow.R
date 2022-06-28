source(testthat::test_path("testdata/data.R"))

study <- Study_Assess(bQuiet = TRUE)

test_that("flowchart is created for all assessments", {
  expect_true("flowchart" %in% names(study$ae$lChecks))
  expect_true("flowchart" %in% names(study$consent$lChecks))
  expect_true("flowchart" %in% names(study$ie$lChecks))
  expect_true("flowchart" %in% names(study$importantpd$lChecks))
  expect_true("flowchart" %in% names(study$pd$lChecks))
  expect_true("flowchart" %in% names(study$sae$lChecks))
  expect_true("flowchart" %in% names(study$aeGrade_1$lChecks))
  expect_true("flowchart" %in% names(study$aeGrade_2$lChecks))
  expect_true("flowchart" %in% names(study$aeGrade_3$lChecks))
  expect_true("flowchart" %in% names(study$aeGrade_4$lChecks))

  expect_type(study$ae$lChecks$flowchart, "list")
  expect_type(study$consent$lChecks$flowchart, "list")
  expect_type(study$ie$lChecks$flowchart, "list")
  expect_type(study$importantpd$lChecks$flowchart, "list")
  expect_type(study$pd$lChecks$flowchart, "list")
  expect_type(study$sae$lChecks$flowchart, "list")
  expect_type(study$aeGrade_1$lChecks$flowchart, "list")
  expect_type(study$aeGrade_2$lChecks$flowchart, "list")
  expect_type(study$aeGrade_3$lChecks$flowchart, "list")
  expect_type(study$aeGrade_4$lChecks$flowchart, "list")

})


