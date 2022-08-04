source(testthat::test_path("testdata/data.R"))

workflows <- MakeAssessmentList()
workflow <- workflows$pd
stratifiedWorkflow <- workflows$pdCategory

data <- list(
    dfSUBJ = dfSUBJ,
    dfPD = dfPD
)

mapping <- yaml::read_yaml(
    system.file('mappings', 'mapping_rawplus.yaml', package = 'gsm')
)

output <- RunAssessment(
    workflow,
    data,
    mapping,
    bQuiet = TRUE
)

stratifiedOutput <- RunStratifiedWorkflow(
    stratifiedWorkflow,
    data,
    mapping
)

test_that("Structure of stratified output matches structure of standard output", {
    expect_equal(class(output), class(stratifiedOutput))
    expect_equal(c(names(output), 'group') %>% sort, names(stratifiedOutput) %>% sort)
})

test_that("Stratified output is returned", {
    expect_true(is.list(stratifiedOutput))
    expect_equal(
        c('chart', 'dfAnalyzed', 'dfBounds', 'dfFlagged', 'dfInput', 'dfSummary', 'dfTransformed', 'lChecks', 'lParams', 'lTags', 'strFunctionName'),
        names(stratifiedOutput$lResults) %>% sort
    )
    expect_equal(
        'stratum',
        names(stratifiedOutput$lResults$chart$facet$params$facets)
    )
    expect_equal(
        nrow(output$lResults$dfSummary)*length(unique(output$lData$dfPD$DVDECOD)),
        nrow(stratifiedOutput$lResults$dfSummary)
    )
})
