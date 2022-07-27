source(testthat::test_path("testdata/data.R"))

workflow <- MakeAssessmentList()$pdCategory
data <- list(
    dfSUBJ = dfSUBJ,
    dfPD = dfPD
)
mapping <- yaml::read_yaml(system.file('mappings', 'mapping_rawplus.yaml', package = 'gsm'))

test_that("Stratified output is returned", {
    output <- runStratifiedWorkflow(
        workflow,
        data,
        mapping
    )
})
