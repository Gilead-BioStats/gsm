#' cli style console appender for gsm
#'
#' @param level warning level that maps to log4r
#' @param ... should contain message and cli_detail
#'
#' @export
cli_fmt <- function(level, ...) {
  fields <- list(...)
  if (level == "INFO" && fields$cli_detail == "h1") {
    cli::cli_h1(fields$message)
  } else if (level == "INFO" && fields$cli_detail == "h2") {
    cli::cli_h2(fields$message)
  } else if (level == "INFO" && fields$cli_detail == "h3") {
    cli::cli_h3(fields$message)
  } else if (level == "INFO" && fields$cli_detail == "alert") {
    cli::cli_alert(fields$message)
  } else if (level == "INFO" && fields$cli_detail == "alert_success") {
    cli::cli_alert_success(fields$message)
  } else if (level == "INFO" && fields$cli_detail == "alert_info") {
    cli::cli_alert_info(fields$message)
  } else if (level == "INFO" && fields$cli_detail == "text") {
    cli::cli_text(fields$message)
  } else if (level == "INFO" && fields$cli_detail == "inform") {
    cli::cli_inform(fields$message)
  } else if (level == "WARN") {
    cli::cli_warn(fields$message)
  } else if (level == "ERROR") {
    cli::cli_abort(fields$message)
  } else if (level == "FATAL") {
    cli::cli_abort(fields$message)
  }
  return(NULL)
}

#' Custom logging function that wraps cli messaging
#' @param level logger levels
#' @param message message to display; may contain glue-style placeholders
#' @param cli_detail for cli style alerts the detail for info
#' @param .envir the environment for glue expressions
#'
#' @export
LogMessage <- function(level, message, cli_detail = NULL, .envir = parent.frame()) {
  # Check if message is not already "glued" and apply glue if necessary
  if (!inherits(message, "glue")) {
    message <- glue::glue(message, .envir = .envir)
  }

  # Pass the formatted message to the appropriate logging level
  switch(toupper(level),
    "DEBUG" = log4r::debug(logger = .le$logger, level = toupper(level), message = message),
    "INFO" = log4r::info(logger = .le$logger, level = toupper(level), message = message, cli_detail = cli_detail),
    "WARN" = log4r::warn(logger = .le$logger, level = toupper(level), message = message),
    "ERROR" = log4r::error(logger = .le$logger, level = toupper(level), message = message),
    "FATAL" = log4r::fatal(logger = .le$logger, level = toupper(level), message = message)
  )
}

#' Custom stop message
#' @param cnd condition for stopping
#' @param message message to display; may contain glue-style placeholders
#'
#' @export
stop_if <- function(cnd, message) {
  if (cnd) {
    LogMessage(level = "error", message = message)
  }
}
