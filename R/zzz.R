#' @importFrom utils globalVariables

NULL

globalVariables(c("."))

# Default logger object
.onLoad <- function(libname, pkgname) {
  # Set a default logger name and instance on package load
  SetLogger()
}
