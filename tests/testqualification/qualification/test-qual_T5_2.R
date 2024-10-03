## Test Setup
kri_workflows <- c(MakeWorkflowList(c("kri0001", "cou0001")), MakeWorkflowList("kri0001_custom", yaml_path_custom_metrics))

partial_mapped_workflows <- map(kri_workflows, ~ robust_runworkflow(.x, mapped_data, steps = 1:6))

## Test Code
testthat::test_that("Given appropriate raw participant-level data, flag values are correctly assigned as NA for sites with low enrollment.", {
  # define custom min denominator
  test_nMinDenominator <- c(500, 1000, 1500)

  # test output row size
  test_output <- map(test_nMinDenominator, function(test) {
    a <- map(partial_mapped_workflows, ~ cli::cli_fmt(Summarize(.x$Analysis_Flagged, nMinDenominator = test))[1])
    map(a, ~ as.numeric(str_extract(., "(\\d+)(?=\\s+Site)")))
  })

  hardcode_output <- map(test_nMinDenominator, function(test) {
    original <- map(partial_mapped_workflows, ~ nrow(.x$Analysis_Flagged))

    filt <- map(partial_mapped_workflows, function(df) {
      df$Analysis_Flagged %>%
        filter(Denominator >= test) %>%
        nrow()
    })

    imap(original, ~ .x - filt[[.y]])
  })

  expect_equal(test_output, hardcode_output)

  # test for identical output
  yaml_test <- map(test_nMinDenominator, function(test) {
    for (workflow in names(kri_workflows)) {
      kri_workflows[[workflow]]$steps[[6]]$params$nMinDenominator <- test
    }
    imap(partial_mapped_workflows, ~ robust_runworkflow(kri_workflows[[.y]], .x, steps = 6, bKeepInputData = F)[["Analysis_Summary"]])
  })

  function_test <- map(test_nMinDenominator, function(test) {
    map(partial_mapped_workflows, ~ Summarize(.x$Analysis_Flagged, nMinDenominator = test))
  })

  expect_identical(yaml_test, function_test)
})
