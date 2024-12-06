#' set the default package logger
#' @param logger a log4r logger
#' @export
SetLogger <- function(logger) {
  if (!inherits(logger, "logger")) {
    rlang::abort("logger must be of class `logger` from log4r")
  }
  .le$logger <- logger
  return(invisible(NULL))
}
