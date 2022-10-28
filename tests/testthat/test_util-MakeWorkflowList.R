lMeta = list(
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
  expect_snapshot(names(wf_list$kri0001))
  expect_snapshot(names(wf_list$kri0002))
  expect_snapshot(names(wf_list$kri0003))
  expect_snapshot(names(wf_list$kri0004))
  expect_snapshot(names(wf_list$kri0005))
  expect_snapshot(names(wf_list$kri0006))
  expect_snapshot(names(wf_list$kri0007))
  expect_snapshot(names(wf_list$qtl0003))
  expect_snapshot(names(wf_list$qtl0007))
})

################################################################################################################

test_that("Metadata is returned as expected", {
  kri0001 <- wf_list$kri0001
  kri0002 <- wf_list$kri0002
  kri0003 <- wf_list$kri0003
  kri0004 <- wf_list$kri0004
  kri0005 <- wf_list$kri0005
  kri0006 <- wf_list$kri0006
  kri0007 <- wf_list$kri0007
  qtl0003 <- wf_list$qtl0003
  qtl0007 <- wf_list$qtl0007

  expect_snapshot(kri0001$steps)
  expect_snapshot(kri0002$steps)
  expect_snapshot(kri0003$steps)
  expect_snapshot(kri0004$steps)
  expect_snapshot(kri0005$steps)
  expect_snapshot(kri0006$steps)
  expect_snapshot(kri0007$steps)
  expect_snapshot(qtl0003$steps)
  expect_snapshot(qtl0007$steps)
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
