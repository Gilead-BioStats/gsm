lMeta <- list(
  config_param = clindata::config_param,
  config_workflow = clindata::config_workflow,
  meta_params = gsm::meta_param,
  meta_site = clindata::ctms_site,
  meta_study = clindata::ctms_study,
  meta_workflow = gsm::meta_workflow
)

strNames <- c(unique(lMeta$meta_workflow$workflowid))

strPath <- "workflow"

bRecursive <- FALSE

wf_list <- MakeWorkflowList(strNames = strNames, bRecursive = bRecursive)

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


test_that("invalid data returns list NULL elements", {
  ### strNames - testing strNames equal to random numeric array
  expect_snapshot(wf_list <- MakeWorkflowList(strNames = "kri8675309", bRecursive = bRecursive))
  expect_true(is.list(wf_list))
  expect_null(wf_list$kri8675309)


  ### strPath - testing strPath equal to non-existent/incorrect location of assessment YAML files
  expect_error(
    MakeWorkflowList(strNames = strNames, strPath = "beyonce", bRecursive = bRecursive)
  )

  ### strPackage - testing strPackage equal to non-existent/incorrect package name
  expect_error(
    MakeWorkflowList(strNames = strNames, strPath = strPath, bRecursive = bRecursive)
  )

  ### bRecursive
  wf_list <- MakeWorkflowList(bRecursive = TRUE, strNames = "aeGrade")$aeGrade
  expect_true(is.list(wf_list))
  expect_length(wf_list, 4)
})


test_that("if lMeta is detected, only active workflows are kept", {
  lMeta <- list(
    config_param = gsm::config_param,
    config_workflow = gsm::config_workflow,
    meta_params = gsm::meta_param,
    meta_site = clindata::ctms_site,
    meta_study = clindata::ctms_study,
    meta_workflow = gsm::meta_workflow
  )

  lMeta$config_workflow <- lMeta$config_workflow %>%
    mutate(
      active = ifelse(workflowid == "kri0001", TRUE, FALSE)
    )

  workflow <- MakeWorkflowList(lMeta = lMeta)

  expect_length(workflow, 1)
  expect_equal(names(workflow), "kri0001")
})


test_that("if lMeta is detected, UpdateParams works as intended", {
  # lMeta$meta_params:  contains default parameters
  # lMeta$config_param: contains custom parameters

  lMeta <- list(
    config_param = gsm::config_param,
    config_workflow = gsm::config_workflow,
    meta_params = gsm::meta_param,
    meta_site = clindata::ctms_site,
    meta_study = clindata::ctms_study,
    meta_workflow = gsm::meta_workflow
  )

  lMeta$config_param <- lMeta$config_param %>%
    mutate(
      value = ifelse(param == "vThreshold", as.numeric(value) + 10, value)
    ) %>%
    suppressWarnings()

  workflow <- MakeWorkflowList(lMeta = lMeta)

  thresholds <- purrr::map(workflow, pluck, "steps") %>%
    purrr::flatten() %>%
    purrr::compact() %>%
    purrr::map(pluck, "params", "vThreshold") %>%
    purrr::discard(is.null)

  expect_length(thresholds, 26)
  expect_snapshot(thresholds)
})
