## Test Setup
source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))
mapping_workflow <- flatten(MakeWorkflowList("mapping", yaml_path_original))
mapped_data <- robust_runworkflow(mapping_workflow, lData)
ae_workflow <- flatten(MakeWorkflowList("kri0001", yaml_path_original))
outputs <- map_vec(ae_workflow$steps, ~.x$output)

## Test Code
testthat::test_that("Given appropriate raw participant-level data, an Adverse Event Assessment can be done using the Normal Approximation method.", {
  test <- robust_runworkflow(ae_workflow, mapped_data$lData)
  expect_true(all(outputs %in% names(test$lData)))
  expect_true(all(map_lgl(test$lData[outputs], is.data.frame)))
  expect_true(all(map_lgl(ae_workflow$steps[3:5], ~str_detect(.x$name, "Normal"))))
})
