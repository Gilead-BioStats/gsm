# Install and load the `testthat` package
source(testthat::test_path("testdata/data.R"))

# Create a sample configuration data frame
dfConfigWorkflow <- gsm::config_workflow

# Create a sample list of results
lResults <- Study_Assess()

# Write a test
test_that("MakeResultsSummary generates correct summary data frame", {
  # Run the MakeResultsSummary function
  results_summary <- MakeResultsSummary(lResults, dfConfigWorkflow)

  # Check if the resulting data frame has the expected structure
  expect_true("studyid" %in% names(results_summary), "Missing 'studyid' column")
  expect_true("workflowid" %in% names(results_summary), "Missing 'workflowid' column")
  expect_true("groupid" %in% names(results_summary), "Missing 'groupid' column")
  expect_true("numerator" %in% names(results_summary), "Missing 'numerator' column")
  expect_true("denominator" %in% names(results_summary), "Missing 'denominator' column")
  expect_true("metric" %in% names(results_summary), "Missing 'metric' column")
  expect_true("score" %in% names(results_summary), "Missing 'score' column")
  expect_true("flag" %in% names(results_summary), "Missing 'flag' column")

  # Check if the resulting data frame has the expected number of rows
  expect_true(is.data.frame(results_summary))
})
