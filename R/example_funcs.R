# example_func
example_func <- function() {
  # Log the start of the function
  log4r::info(.package_logger, "[example_func] Starting function execution.")
  cli_alert_info("This is an info message from example_func.")
  log4r::info(.package_logger, "This is an info message from example_func.")

  cli_alert_success("This is a success message from example_func.")
  log4r::info(.package_logger, "This is a success message from example_func.")

  # Log the completion of the function
  log4r::info(.package_logger, "[example_func] Function completed.")
  return("example_func completed.")
}

# example_func2
example_func2 <- function() {
  # Log the start of the function
  log4r::info(.package_logger, "[example_func2] Starting function execution.")
  cli_alert_info("This is an info message from example_func2.")
  log4r::info(.package_logger, "This is an info message from example_func2.")

  cli_alert_warning("This is a warning message from example_func2.")
  log4r::warn(.package_logger, "This is a warning message from example_func2.")

  # Log the completion of the function
  log4r::info(.package_logger, "[example_func2] Function completed.")
  return("example_func2 completed.")
}
