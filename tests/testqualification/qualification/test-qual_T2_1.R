## Test Setup
source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = 'gsm'))

ae_workflow <- flatten(MakeWorkflowList(strNames = 'kri0001'))

mapped_data <- get_data(ae_workflow, lData)

outputs <- map_vec(ae_workflow$steps, ~.x$output)

## Test Code
testthat::test_that("Given raw participant-level data, a properly specified Workflow for a KRI creates summarized and flagged data", {
  test <- robust_runworkflow(ae_workflow, mapped_data)
  expect_true(all(outputs %in% names(test)))
  expect_true(is.vector(test$vThreshold))
  expect_true(all(map_lgl(test[outputs[outputs != "vThreshold"]], is.data.frame)))
  expect_equal(nrow(test$dfFlagged), nrow(test$dfSummary))
  expect_identical(sort(test$dfFlagged$GroupID), sort(test$dfSummary$GroupID))

})




