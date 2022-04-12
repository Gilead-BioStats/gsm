test_that("Study Table Runs as expected",{
    results<- Study_Assess(bQuiet=TRUE)
    dfSummaryAll <-results %>% map(~.x$result$dfSummary) %>% bind_rows 
    expect_true(is.data.frame(Study_Table(dfSummaryAll)))
})
