# test-util-logger.R
test_that("logger writes to a unique log file", {
  SetLogger(strName = "test_logger")

  # Log a message
  logger <- GetLogger("test_logger")
  log4r::info(logger, "Write to user specified log.")

  # Check if the log file exists and contains the message
  expect_true(file.exists("test_logger.log"))
  log_content <- readLines("test_logger.log")
  expect_true(grepl("Write to user specified", log_content))

  # Clean up the test log file
  file.remove("test_logger.log")
})

