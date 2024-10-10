# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  assessment_list <- suppressWarnings(MakeWorkflowList())

  expect_snapshot(names(assessment_list))
  expect_type(assessment_list, "list")
  expect_true(all(map_lgl(assessment_list, ~ all(c("meta", "steps", "path") %in% names(.)))))
})
