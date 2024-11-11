cli_log_info <- function(message) {
  cli::cli_inform(message)
  log4r::info(.package_logger, message)
}

cli_log_warn <- function(message) {
  cli::cli_warn(message)
  log4r::warn(.package_logger, message)
}

cli_log_error <- function(message) {
  cli::cli_abort(message)
  log4r::error(.package_logger, message)
}
