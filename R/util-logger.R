#' Set a Custom Logger Object
#'
#' @param logger A logger object
#' @export
#' @return an option holding the logger
SetLogger <- function(logger) {
  if (!inherits(logger, "logger")) {
    stop("The provided logger must be a 'log4r_logger' object.")
  }
  options(gsm_logger = logger, gsm_usecli = FALSE)
  invisible(logger)
}
#' Get a Custom Logger Object
#' @export
#' @return an option holding the logger
GetLogger <- function() {
  logger <- getOption("gsm_logger")
  if (is.null(logger)) stop("Logger is not set. Use `SetLogger()` to initialize.")
  return(logger)
}
