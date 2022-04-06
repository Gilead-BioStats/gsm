test_that("Study Table Report runs as expected",{
    results<- Study_Assess(bQuiet=TRUE) %>% map(~.x$result)
    Study_Report(assessments=results, meta=list(Project="My Study"))
})
devtools::install()
