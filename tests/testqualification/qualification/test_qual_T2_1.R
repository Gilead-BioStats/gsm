## Test Setup
raw_data <- clindata::rawplus_ae
ae_workflow <- flatten(MakeWorkflowList("kri0001"))
mapping_workflow <- flatten(MakeWorkflowList("mapping"))
mapped_data <- RunWorkflow(mapping_workflow, lData = list(dfAE = clindata::rawplus_ae))


## Test Code
testthat::test_that("Given raw participant-level data, a properly specified Workflow for a KRI creates summarized and flagged data", {
  test <- RunWorkflow(ae_workflow, raw_data)
})
