source(testthat::test_path("testdata/data.R"))

snapshot <- Make_Snapshot()

# Output is created as expected -------------------------------------------
test_that("Output is created as expected", {
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
})


# Incorrect inputs throw errors -------------------------------------------
test_that("Incorrect inputs throw errors", {
  expect_null(Make_Snapshot("Hi")[["lData"]])

})
