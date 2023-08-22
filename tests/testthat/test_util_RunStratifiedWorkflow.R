source(testthat::test_path("testdata/data.R"))

workflows <- MakeWorkflowList(bRecursive = TRUE, strNames = c("pdCategory", "kri0004"))
workflow <- workflows$kri0004
workflow$steps[[1]] <- NULL # remove filtering to mimic standard PD_Map_Raw_Rate() %>% PD_Assess_Rate()
workflow$steps[[1]] <- NULL
stratifiedWorkflow <- workflows$pdCategory

data <- list(
  dfSUBJ = dfSUBJ,
  dfPD = dfPD
)

mapping <- c(
  yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
  yaml::read_yaml(system.file("mappings", "mapping_ctms.yaml", package = "gsm"))
)

output <- RunWorkflow(
  workflow,
  data,
  mapping,
  bQuiet = TRUE
)

stratifiedOutput <- RunStratifiedWorkflow(
  stratifiedWorkflow,
  data,
  mapping
) %>%
  suppressWarnings()

test_that("Structure of stratified output matches structure of standard output", {
  expect_equal(class(output), class(stratifiedOutput))
  expect_equal(c(names(output), "group") %>% sort(), names(stratifiedOutput) %>% sort())
})

test_that("Stratified output is returned", {
  expect_true(is.list(stratifiedOutput))
  expect_equal(
    c("chart", "dfAnalyzed", "dfBounds", "dfFlagged", "dfSummary", "dfTransformed", "lCharts", "lChecks", "lData"),
    names(stratifiedOutput$lResults) %>% sort()
  )
  expect_equal(
    "stratum",
    names(stratifiedOutput$lResults$chart$facet$params$facets)
  )
  expect_equal(
    nrow(output$lResults$lData$dfSummary) * length(unique(output$lData$dfPD$companycategory)),
    nrow(stratifiedOutput$lResults$dfSummary)
  )
})
