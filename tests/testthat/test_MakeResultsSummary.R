# Install and load the `testthat` package
source(testthat::test_path("testdata/data.R"))

# Create a sample configuration data frame
dfConfigWorkflow <- data.frame(
  studyid = c("Study1", "Study2"),
  KRIID = c("Workflow1", "Workflow2"),
  GroupID = c("GroupA", "GroupB")
)

# Create a sample list of results
lResults <- list(
  list(
    lResults = list(
      lChecks = list(status = TRUE),
      lData = list(
        dfSummary = data.frame(
          Numerator = c(1, 2),
          Denominator = c(10, 20),
          Metric = c("MetricA", "MetricB"),
          Score = c(0.1, 0.2),
          Flag = c("OK", "Warning")
        )
      )
    )
  ),
  # Add more result entries as needed for testing different cases
)
Upda
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
  expect_equal(nrow(results_summary), sum(sapply(lResults, function(x) !is.null(x$lResults) && x$lResults$lChecks$status)))
})
