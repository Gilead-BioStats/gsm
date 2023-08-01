#' Unlog - stop logging.
#'
#' @keywords internal
#'
#' @export
Unlog <- function() {
  sink()
  sink(type = "message")
}
