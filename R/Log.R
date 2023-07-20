#' Log output.
#'
#' @param strFileName `character` File name or full path to a directory to save the log file.
#'
#' @keywords internal
#'
#' @importFrom cli cli_h1
#' @importFrom utils sessionInfo
#'
#' @export
Log <- function(strFileName = NULL) {

  if (is.null(strFileName)) {
    strFileName <- paste0("gsm_log_", make.names(Sys.time()), ".log")
  } else {
    strFileName <- paste0(strFileName, ".log")
  }

  con <- file(strFileName)
  sink(con, append = TRUE)
  sink(con, append = TRUE, type = "message")
  cli::cli_h1("BEGIN SESSION INFO")
  print(sessionInfo())
  cli::cli_h1("END SESSION INFO")

}
