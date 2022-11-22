lMeta <- list(
  config_param = clindata::config_param,
  config_schedule = clindata::config_schedule,
  config_workflow = clindata::config_workflow,
  meta_params = gsm::meta_param,
  meta_site = clindata::ctms_site,
  meta_study = clindata::ctms_study,
  meta_workflow = gsm::meta_workflow
)

strNames <- c(unique(lMeta$meta_workflow$workflowid))

strPath <- "workflow"

strPackage <- "gsm"

bRecursive <- FALSE

wf_list <- MakeWorkflowList(strNames = strNames, strPath = strPath, strPackage = strPackage, bRecursive = bRecursive)

################################################################################################################

test_that("output is generated as expected", {
  expect_true(is.list(wf_list))
  expect_true(all(map_chr(wf_list, ~ class(.)) == "list"))
  expect_snapshot(map(wf_list, ~ names(.)))
})

################################################################################################################

test_that("Metadata is returned as expected", {
  expect_snapshot(map(wf_list, ~ .x$steps))
})

################################################################################################################

test_that("invalid data returns list of 0 elements", {


  ### strNames - testing strNames equal to random numeric array
  strNames_edited <- array(1:12, dim = c(2, 3, 2))
  wf_list <- MakeWorkflowList(strNames = strNames_edited, strPath = strPath, strPackage = strPackage, bRecursive = bRecursive)
  expect_true(is.list(wf_list))
  expect_length(wf_list, 0)


  ### strPath - testing strPath equal to non-existent/incorrect location of assessment YAML files
  strPath_edited <- "beyonce"
  wf_list <- MakeWorkflowList(strNames = strNames, strPath = strPath_edited, strPackage = strPackage, bRecursive = bRecursive)
  expect_true(is.list(wf_list))
  expect_length(wf_list, 0)


  ### strPackage - testing strPackage equal to non-existent/incorrect package name
  strPackage_edited <- "piper"
  wf_list <- MakeWorkflowList(strNames = strNames, strPath = strPath, strPackage = strPackage_edited, bRecursive = bRecursive)
  expect_true(is.list(wf_list))
  expect_length(wf_list, 0)

  strPackage_edited <- "dplyr"
  wf_list <- MakeWorkflowList(strNames = strNames, strPath = strPath, strPackage = strPackage_edited, bRecursive = bRecursive)
  expect_true(is.list(wf_list))
  expect_length(wf_list, 0)


  ### bRecursive
  wf_list <- MakeWorkflowList(bRecursive = TRUE, strNames = "aeGrade")$aeGrade
  expect_true(is.list(wf_list))
  expect_length(wf_list, 4)
})
