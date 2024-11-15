#' @importFrom utils globalVariables

NULL

globalVariables(c("."))

# Default logger object
.onLoad <- function(libname, pkgname) {
  options(gsm_usecli = TRUE)
}
