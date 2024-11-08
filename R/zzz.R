#' @importFrom utils globalVariables

NULL

globalVariables(c("."))


.package_logger <- log4r::logger(
  threshold = "INFO",
  appenders = log4r::file_appender("gsm_log.log")
)

.onLoad <- function(libname, pkgname) {
  # Make sure .package_logger is available when package loads
  if (!exists(".package_logger", envir = asNamespace(pkgname))) {
    assign(".package_logger",
           log4r::logger(threshold = "INFO", appenders = log4r::file_appender("gsm_log.log")),
           envir = asNamespace(pkgname))
  }
}
