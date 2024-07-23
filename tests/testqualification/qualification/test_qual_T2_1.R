## Test Setup
source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = 'gsm'))

mapping_workflow <- flatten(MakeWorkflowList('mapping', yaml_path_original))
ae_workflow <- flatten(MakeWorkflowList(strNames = 'kri0001', strPath = yaml_path_original))
mapped_data <- get_data(ae_workflow, lData)

outputs <- map_vec(ae_workflow$steps, ~.x$output)

## Test Code
testthat::test_that("Given raw participant-level data, a properly specified Workflow for a KRI creates summarized and flagged data", {
  test <- robust_runworkflow(ae_workflow, mapped_data)
  expect_true(all(outputs %in% names(test$lData)))
  expect_true(is.vector(test$lData[["vThreshold"]]))
  expect_true(all(map_lgl(test$lData[outputs[outputs != "vThreshold"]], is.data.frame)))
  expect_equal(nrow(test$lData$dfFlagged), nrow(test$lData$dfSummary))
  expect_identical(sort(test$lData$dfFlagged$GroupID), sort(test$lData$dfSummary$GroupID))

})




