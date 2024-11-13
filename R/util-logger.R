# utils-logger.R

# Function to set up a logger with flexible output options
set_logger <- function(name = NULL,
                       output_target = "file",
                       log_level = "INFO",
                       metadata = list()) {
  if(is.null(name)){
    name <- "gsm_log"
  }
  log_file <- make_log_file(name)

  # Determine appenders based on the `output_target`
  appenders <- switch(output_target,
                      console = list(log4r::console_appender()),
                      file = list(log4r::file_appender(log_file)),  # Default file name or user-provided file
                      both = list(log4r::console_appender(), log4r::file_appender(log_file)),
                      stop("Invalid output_target. Choose 'console', 'file', or 'both'."))

  # Create a logger with specified settings
  logger <- log4r::logger(
    threshold = log_level,
    appenders = appenders
  )

  # Attach metadata to the logger instance
  attr(logger, "metadata") <- metadata

  # Dynamically construct the option name
  option_name <- paste0("my_pkg_logger_", name)

  # Use rlang::call to construct the options() call
  options_call <- call("options", setNames(list(logger), option_name))

  # Evaluate the call to set the logger in options
  eval_tidy(options_call)

  invisible(logger)  # Return the logger invisibly
}

# Function to retrieve the logger by name, using the default if no name is provided
get_logger <- function(name = NULL) {
  if (is.null(name)) {
    name <- getOption("my_pkg_default_logger_name")
  }

  # Fetch the logger by the resolved name
  logger <- getOption(paste0("my_pkg_logger_", name))

  # Error if the logger does not exist
  if (is.null(logger)) stop("Logger '", name, "' not found. Please call `set_logger(name = '", name, "')` first.")

  logger
}

make_log_file <- function(name) {
  # Define the filename and path
  file_name <- paste0(name, ".log", sep = "")
  file_path <- file.path(getwd(), file_name)
  file.create(paste0(file_path))
  absolute_path <- normalizePath(file_path)
  return(absolute_path)
}
