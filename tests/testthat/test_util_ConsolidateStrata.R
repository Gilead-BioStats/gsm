source(testthat::test_path("testdata/data.R"))

lData <- list(
  dfSUBJ = clindata::rawplus_subj,
  dfAE = clindata::rawplus_ae
)
lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))
lWorkflow <- MakeAssessmentList(bRecursive = TRUE, strNames = "aeGrade")$aeGrade
lOutput <- RunAssessment(lWorkflow, lData = lData, lMapping = lMapping, bQuiet = TRUE)
lStratifiedWorkflow <- MakeStratifiedAssessment(
  lWorkflow,
  lData,
  lMapping
)
lStratifiedOutput <- lStratifiedWorkflow %>%
  purrr::map(~ RunAssessment(
    .x,
    lData,
    lMapping
  ))
lConsolidatedOutput <- ConsolidateStrata(
  lOutput,
  lStratifiedOutput
)

test_that("Structure of consolidated output matches structure of standard output", {
  expect_equal(class(lOutput), class(lConsolidatedOutput))
  expect_equal(names(lOutput) %>% sort(), names(lConsolidatedOutput) %>% sort())
})

test_that("Stratified output is returned", {
  expect_true(is.list(lConsolidatedOutput))
  expect_equal(
    c("chart", "dfAnalyzed", "dfBounds", "dfFlagged", "dfInput", "dfSummary", "dfTransformed", "lChecks", "lTags", "strFunctionName"),
    names(lConsolidatedOutput$lResults) %>% sort()
  )
  expect_equal(
    "stratum",
    names(lConsolidatedOutput$lResults$chart$facet$params$facets)
  )
  expect_equal(
    nrow(lOutput$lResults$dfSummary) * length(unique(lOutput$lData$dfAE$AE_GRADE)),
    nrow(lConsolidatedOutput$lResults$dfSummary)
  )
})
