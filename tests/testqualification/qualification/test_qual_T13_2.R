## Test Setup
source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))
mapping_workflow <- flatten(MakeWorkflowList("mapping", yaml_path))

## Test Code
testthat::test_that("Query Rate Assessments can be done correctly using a grouping variable, such as Site, Country, or Study, when applicable.", {

})
