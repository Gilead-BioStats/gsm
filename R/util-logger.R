# utils-logger.R

# Function to set up a logger with flexible output options
#' Title
#'
#' @param strName User defined name for the logger/log
#' @param strOutputTarget Destination to sending logging to
#' @param strLogLevel level of logs to include
#' @param lMetadata a list of desired metadata to be collected
#'
#' @return logger object
#' @export
set_logger <- function(strName = "gsm",
                       strOutputTarget = "file",
                       strLogLevel = "INFO",
                       lMetadata = create_logger_metadata()) {

  # Assertion for strName
  stopifnot("`strName` must be of type `character`" = is.character(strName))

  # Assertion for strLogLevel
  loglevelchar <- names(log4r::available.loglevels())
  message = paste0(
    glue::glue("`strLogLevel` must be one of:"),
    glue::glue("{glue::glue_collapse(loglevelchar, sep = ', ')}.")
  )
  if (!(strLogLevel %in% loglevelchar)) {
    stop(message)
  }

  # Make log file
  log_file <- make_log_file(strName)

  # Determine appenders based on the `output_target`
  # Assertion for strOutputTarget is baked in with the switch/stop message
  appenders <- switch(
    strOutputTarget,
    console = list(log4r::console_appender()), # this would duplicate many of our cli messaging
    file = list(log4r::file_appender(log_file)),
    both = list(log4r::console_appender(), log4r::file_appender(log_file)),
    stop("Invalid `strOutputTarget`. Choose 'console', 'file', or 'both'.")
  )


  # Create a logger with specified settings
  logger <- log4r::logger(
    threshold = strLogLevel,
    appenders = appenders
  )

  # Attach metadata to the logger instance
  attr(logger, "lMetadata") <- lMetadata

  # Dynamically construct the option name
  option_name <- paste0("my_pkg_logger_", strName)

  # Use rlang::call to construct the options() call
  options_call <- call("options", setNames(list(logger), option_name))

  # Evaluate the call to set the logger in options
  eval_tidy(options_call)

  invisible(logger)  # Return the logger invisibly
}

# Function to retrieve the logger by name, using the default if no name is provided
#' Title
#'
#' @param strName Retrive logger object
#'
#' @return logger object
#' @export
get_logger <- function(strName = "gsm") {
  # Fetch the logger by the resolved name
  logger <- getOption(paste0("my_pkg_logger_", strName))

  # Error if the logger does not exist
  if (is.null(logger)) {
    stop("Logger '", strName, "' not found. Please call `set_logger(name = '", strName, "')` first.")
  }
  logger
}

make_log_file <- function(name) {
  # Define the filename and path
  # Should log making be separate?
  # Trying to wrap the set/get into one function calls each, reduce arguments in all the other functions
  file_name <- paste0(name, ".log", sep = "")
  file_path <- file.path(getwd(), file_name)
  file.create(paste0(file_path))
  absolute_path <- normalizePath(file_path)
  return(absolute_path)
}

create_logger_metadata <- function(){
  # Can add more things, throw em into a list?
  lMetadata <- list(
    r_version = R.version,
    user = Sys.info()[["user"]],
    renv = ifelse(file.exists("renv.lock"), "present", "not present")
  )
  return(lMetadata)
}
