## Test Setup
source(system.file("tests", "testqualification", "qualification", "qual_data.R", package = "gsm"))
mapping_workflow <- flatten(MakeWorkflowList("mapping", yaml_path_original))
ae_workflow <- flatten(MakeWorkflowList('kri0001_custom', yaml_path_custom))
mapped_data <- get_data(ae_workflow, lData)
partial_ae_workflow <- robust_runworkflow(ae_workflow, mapped_data, steps = 1:6)
## Test Code
testthat::test_that("Given appropriate raw participant-level data, flag values are correctly assigned as NA for sites with low enrollment.", {
  # define custom min denominator
  test_nMinDenominator <- c(500, 1000, 1500)

  # test output row size
  test_output <- map(test_nMinDenominator, function(test){
    a <- cli::cli_fmt(Summarize(partial_ae_workflow$lData$dfFlagged, nMinDenominator = test))[1]
    as.numeric(str_extract(a, "(\\d+)(?=\\s+Site)"))
  })

  hardcode_output <- map(test_nMinDenominator, function(test){
    original <- nrow(partial_ae_workflow$lData$dfFlagged)

    filt <- partial_ae_workflow$lData$dfFlagged %>%
      filter(Denominator >= test) %>%
      nrow()

    original - filt
  })

  expect_equal(test_output, hardcode_output)

  # test for identical output
  yaml_test <- map(test_nMinDenominator, function(test){
    ae_workflow$steps[[6]]$params$nMinDenominator <- test
    robust_runworkflow(ae_workflow, partial_ae_workflow$lData, steps = 6)$lData['dfSummary']
  }) %>%
    flatten() %>%
    setNames(NULL)

  function_test <- map(test_nMinDenominator, function(test){
    Summarize(partial_ae_workflow$lData$dfFlagged, nMinDenominator = test)
  })

  expect_identical(yaml_test, function_test)

})




