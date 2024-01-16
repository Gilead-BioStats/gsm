# Install and load the `testthat` package
source(testthat::test_path("testdata/data.R"))
getwd()

test_that("Log function creates a log file", {
  # Run the Log function
  Log()

  # Extract the generated log file name
  log_file <- dir(pattern = "gsm_log_.*\\.log", full.names = TRUE)

  # Check if the log file exists
  expect_true(file.exists(log_file), "Log file should be created")

  # Clean up: remove the created log file
  unlink(log_file)
  sink()
})



