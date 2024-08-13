## Test Setup
source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))

ae_workflow <- flatten(MakeWorkflowList("kri0001"))

steps <- c(1, 3:length(ae_workflow$steps))

outputs <- map_vec(ae_workflow$steps[steps], ~ .x$output)

## Test Code
testthat::test_that("Given pre-processed input data, a properly specified Workflow for a KRI creates summarized and flagged data", {
  test <- robust_runworkflow(ae_workflow, list(dfInput = gsm::analyticsInput), step = steps)
  expect_true(all(outputs %in% names(test)))
  expect_true(is.vector(test$vThreshold))
  expect_true(all(map_lgl(test[outputs[outputs != "vThreshold"]], is.data.frame)))
  expect_equal(nrow(test$dfFlagged), nrow(test$dfSummary))
  expect_identical(sort(test$dfFlagged$GroupID), sort(test$dfSummary$GroupID))
})
