#' cli style console appender for gsm
#'
#' @param level warning level that maps to log4r
#' @param ... should contain message and cli_detail
#'
#' @return
#' @export
#'
#' @examples
cli_fmt <- function(level, ...) {
  fields <- list(...)
  if (level == "INFO" && fields$cli_detail == "h1") {
    cli::cli_h1(fields$message)
  } else if (level == "INFO" && fields$cli_detail == "h2") {
    cli::cli_h2(fields$message)
  } else if (level == "INFO" && fields$cli_detail == "h3") {
    cli::cli_h3(fields$message)
  } else if (level == "INFO" && fields$cli_detail == "success") {
    cli::cli_alert_success(fields$message)
  } else if (level == "WARN") {
    cli::cli_alert_warning(fields$message)
  } else if (level == "ERROR") {
    cli::cli_alert_danger(fields$message)
  } else {
    cli::cli_alert_info(fields$message)
  }
  return(NULL)
}

#' @export
LogMessage <- function(level, message, cli_detail) {
  switch(
    toupper(level),
    "DEBUG" = log4r::debug(logger = .le$logger),
    "INFO" = log4r::info(logger = .le$logger, message = message, cli_detail = cli_detail),
    "WARN" = log4r::warn(logger = .le$logger, message = message),
    "ERROR" = log4r::error(logger = .le$logger, message = message),
    "FATAL" = log4r::fatal(logger = .le$logger)
  )
}

