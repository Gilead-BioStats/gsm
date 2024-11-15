LogMessage <- function(type, cli_detail = NULL, message) {
  # Check the current setting for CLI usage
  use_cli <- getOption("gsm_usecli", TRUE) # Default to TRUE if the option is not set

  # Dynamically evaluate the message with glue
  message <- glue::glue(message, .envir = parent.frame(),)

  if (use_cli) {
    # Handle CLI-based messaging
    if (type == "info") {
      if (cli_detail == "reg") {
        cli::cli_inform(message)
      } else if (cli_detail == "success") {
        cli::cli_alert_success(message)
      } else if (cli_detail == "h1") {
        cli::cli_h1(message)
      } else if (cli_detail == "h2") {
        cli::cli_h2(message)
      } else if (cli_detail == "h3") {
        cli::cli_h3(message)
      } else {
        stop("Invalid cli_detail specified for info type.")
      }
    } else if (type == "warning") {
      cli::cli_warn(message)
    } else if (type == "error") {
      cli::cli_abort(message)
    } else {
      stop("Invalid type specified for CLI logging.")
    }
  } else {
    # Handle log4r-based logging
    logger <- GetLogger()
    if (type == "info") {
      log4r::info(logger, message)
    } else if (type == "warning") {
      log4r::warn(logger, message)
    } else if (type == "error") {
      log4r::error(logger, message)
    } else {
      stop("Invalid type specified for log4r logging.")
    }
  }
}
