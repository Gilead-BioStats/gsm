#' do some work
#' @param reps fake argument
#' @export
do_work <- function(message, cli_det) {
  log_info(.le$logger, message = message, cli_det = cli_det)
  return(TRUE)
}

