## Test Setup
source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))
mapping_workflow <- flatten(MakeWorkflowList("mapping", yaml_path))

## Test Code
testthat::test_that("Given appropriate raw participant-level data, flag values are correctly assigned as NA for sites with low enrollment.", {

})
