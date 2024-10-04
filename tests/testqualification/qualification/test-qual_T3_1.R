## Test Setup
ae_workflow <- flatten(MakeWorkflowList("kri0001b_custom", strPath = yaml_path_custom_metrics))

steps <- seq(1, length(ae_workflow$steps))

outputs <- map_vec(ae_workflow$steps[steps], ~ .x$output)

## Test Code
testthat::test_that("Given pre-processed input data, a properly specified Workflow for a KRI creates summarized and flagged data", {
  test <- robust_runworkflow(ae_workflow, list(Analysis_Input = gsm::analyticsInput), step = steps)
  expect_true(all(outputs %in% names(test)))
  expect_true(is.vector(test$vThreshold))
  expect_true(all(map_lgl(test[outputs[!(outputs %in% c("vThreshold", "lAnalysis"))]], is.data.frame)))
  expect_equal(nrow(test$Analysis_Flagged), nrow(test$Analysis_Summary))
  expect_identical(sort(test$Analysis_Flagged$GroupID), sort(test$Analysis_Summary$GroupID))
})
