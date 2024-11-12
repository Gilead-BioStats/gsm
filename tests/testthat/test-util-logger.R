# test-utils-logger.R
test_that("default logger works as expected", {
  # Retrieve the default logger
  default_logger <- get_logger("default")

  # Check that the default logger exists
  log4r::info(default_logger, "Default writes to gsm_log.log")
  expect_true(!is.null(default_logger))
  default_log_content <- readLines("gsm_log.log")
  expect_true(grepl("Default writes to", default_log_content))
  file.remove("gsm_log.log")
})

# Example unit test for set_logger

test_that("logger writes to a unique log file", {
  log_file <- tempfile("test_log_", fileext = ".log")

  # Set a logger with the unique log file
  set_logger(name = "test_logger", output_target = "file", log_file = log_file)

  # Log a message
  logger <- get_logger("test_logger")
  log4r::info(logger, "Write to user specified log.")

  # Check if the log file exists and contains the message
  expect_true(file.exists(log_file))
  log_content <- readLines(log_file)
  expect_true(grepl("Write to user specified", log_content))

  # Clean up the test log file
  file.remove(log_file)
})

