source(testthat::test_path("testdata/data.R"))

snapshot <- Make_Snapshot()

# Output is created as expected -------------------------------------------
test_that("output is created as expected", {
  expect_true(is.list(snapshot))
  expect_equal(names(snapshot), c("status_study", "status_site", "status_workflow", "status_param", "status_schedule", "results_summary", "results_bounds", "meta_workflow", "meta_param"))
  expect_true("data.frame" %in% class(snapshot$status_study))
  expect_true("data.frame" %in% class(snapshot$status_site))
  expect_true("data.frame" %in% class(snapshot$status_workflow))
  expect_true("data.frame" %in% class(snapshot$status_param))
  expect_true("data.frame" %in% class(snapshot$status_schedule))
  expect_true("data.frame" %in% class(snapshot$results_summary))
  expect_true("data.frame" %in% class(snapshot$results_bounds))
  expect_true("data.frame" %in% class(snapshot$meta_workflow))
  expect_true("data.frame" %in% class(snapshot$meta_param))
  expect_equal(names(snapshot$status_study), c("studyid", "enrolled_sites", "enrolled_participants", "planned_sites", "planned_participants", "title", "nickname", "indication", "ta", "phase", "status", "fpfv", "lplv", "rbm_flag"))
  expect_equal(names(snapshot$status_site), c("studyid", "siteid", "institution", "status", "enrolled_participants", "start_date", "city", "state", "country", "invname"))
  expect_equal(names(snapshot$status_workflow), c("studyid", "workflowid", "gsm_version", "active", "status", "notes"))
  expect_equal(names(snapshot$status_param), c("studyid", "workflowid", "gsm_version", "param", "index", "value"))
  expect_equal(names(snapshot$status_schedule), c("studyid", "snapshot_date"))
  expect_equal(names(snapshot$results_summary), c("studyid", "workflowid", "groupid", "numerator", "denominator", "metric", "score", "flag"))
  expect_equal(names(snapshot$results_bounds), c("studyid", "workflowid", "threshold", "numerator", "denominator", "log_denominator"))
  expect_equal(names(snapshot$meta_workflow), c("workflowid", "gsm_version", "group", "metric", "numerator", "denominator", "outcome", "model", "score", "data_inputs", "data_filters"))
  expect_equal(names(snapshot$meta_param), c("workflowid", "gsm_version", "param", "index", "default", "configurable"))
})


# Incorrect inputs throw errors -------------------------------------------
test_that("Incorrect inputs throw errors", {
  expect_null(Make_Snapshot("Hi")[["lData"]])

})
