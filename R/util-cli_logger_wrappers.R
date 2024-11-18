#' @export
LogMessage <- function(level, message, cli_detail = NULL) {
  switch(
    toupper(level),
    "INFO" = log_info(logger = .le$logger, message = message, cli_detail = cli_detail),
    "WARN" = log_warn(logger = .le$logger, message = message),
    "ERROR" = log_error(logger = .le$logger, message = message)
  )
}

