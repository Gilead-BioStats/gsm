#' @importFrom utils globalVariables

NULL

globalVariables(c("."))

# Default logger object
# Initialize a default logger at package load
.onLoad <- function(libname, pkgname) {
  cli_fmt <- function(level, ...) {
    fields <- list(...)
    if (level == "INFO" && fields$cli_det == "h1") {
      cli::cli_h1(fields$message)
    } else if (level == "INFO" && fields$cli_det == "h2") {
      cli::cli_h2(fields$message)
    } else if (level == "INFO" && fields$cli_det == "h3") {
      cli::cli_h3(fields$message)
    } else if (level == "INFO" && fields$cli_det == "success") {
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
  logger <- logger("DEBUG",
                   appenders = console_appender(cli_fmt)
  )
  SetLogger(logger)
}

