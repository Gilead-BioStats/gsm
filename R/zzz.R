#' @importFrom utils globalVariables

NULL

globalVariables(c("."))

# Default logger object
# Initialize a default logger at package load
.onLoad <- function(libname, pkgname) {
  logger <- logger("DEBUG")
  SetLogger(logger)
}

