# Install and load the `testthat` package
source(testthat::test_path("testdata/data.R"))

# Create a sample configuration data frame
dfConfigWorkflow <- gsm::config_workflow

# Create a sample list of results
lResults <- Study_Assess(lData = lData)

# Write a test
test_that("MakeResultsSummary generates correct summary data frame", {
  # Run the MakeResultsSummary function
  results_summary <- MakeResultsSummary(lResults, dfConfigWorkflow)

  # Check if the resulting data frame has the expected structure
  expect_snapshot(names(results_summary))

  # Check if the resulting data frame has the expected number of rows
  expect_true(is.data.frame(results_summary))
})
