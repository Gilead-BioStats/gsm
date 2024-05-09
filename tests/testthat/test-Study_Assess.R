
library(testthat)
library(gsm)
library(purrr)
library(cli)
library(dplyr)
library(clindata)
library(mockery)

test_that("Study_Assess handles NULL input for lData and lAssessments", {
  mock_use_clindata <- mock(list(test_data = "Mocked Data"))
  mock_make_workflow_list <- mock(list(test_workflow = "Mocked Workflow"))

  with_mock(
    `gsm::UseClindata` = mock_use_clindata,
    `gsm::MakeWorkflowList` = mock_make_workflow_list,
    {
      result <- Study_Assess()
      expect_is(result, "list")
      expect_equal(result, list(test_workflow = "Mocked Workflow"))
    }
  )
})

test_that("Study_Assess handles existing lData and lAssessments", {
  lData <- list(dfSUBJ = data.frame(col1 = 1:5))
  lAssessments <- list(function(data) return(data))

  mock_run_workflow <- mock(lData)

  result <- with_mock(
    `RunWorkflow` = mock_run_workflow,
    {
      Study_Assess(lData, lAssessments)
    }
  )

  expect_equal(result, list(lData))
})

test_that("Study_Assess alerts when dfSUBJ is empty", {
  lData <- list(dfSUBJ = data.frame())
  lAssessments <- list(function(data) return(data))

  expect_cli_alert_danger({
    result <- Study_Assess(lData, lAssessments)
    expect_equal(result, NULL)
  }, "Subject-level data contains 0 rows. Assessment not run.")
})

test_that("Study_Assess alerts when dfSUBJ is missing", {
  lData <- list(notDfSUBJ = data.frame(col1 = 1:5))
  lAssessments <- list(function(data) return(data))

  expect_cli_alert_danger({
    result <- Study_Assess(lData, lAssessments)
    expect_equal(result, NULL)
  }, "Subject-level data not found. Assessment not run.")
})

test_that("Study_Assess works with non-empty dfSUBJ but null assessments by default", {
  lData <- list(dfSUBJ = data.frame(col1 = 1:5))
  mock_make_workflow_list <- mock(list(test_workflow = "Mocked Workflow"))

  with_mock(
    `gsm::MakeWorkflowList` = mock_make_workflow_list,
    `RunWorkflow` = identity,
    {
      result <- Study_Assess(lData)
      expect_equal(result, list(test_workflow = "Mocked Workflow"))
    }
  )
})

