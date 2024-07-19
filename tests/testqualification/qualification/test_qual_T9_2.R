## Test Setup
source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))
mapping_workflow <- flatten(MakeWorkflowList("mapping", yaml_path))

## Test Code
testthat::test_that("Labs Assessments can be done correctly using a grouping variable, such as Site or Country for KRIs, and Study for QTLs, when applicable.", {

})
