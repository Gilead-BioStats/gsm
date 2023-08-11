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

  # from quick research, these are common env variables to store user info
  possible_user_identity <- Sys.getenv(c("USER", "USERNAME", "RSTUDIO_USER_IDENTITY"))

  con <- file(strFileName)
  sink(con, append = TRUE)
  sink(con, append = TRUE, type = "message")
  cli::cli_h1("BEGIN SESSION INFO")
  print(paste0("User: ", max(possible_user_identity)))
  print(paste0("Time: ", Sys.time()))
  print(sessionInfo())
  cli::cli_h1("END SESSION INFO")
}
