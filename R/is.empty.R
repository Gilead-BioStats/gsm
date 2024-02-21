#' detect empty spaces in variables
#'
#' @param x `variable` the variable to perform logical checks to
#'
#' @export
#' @keywords internal
is.empty <- function(x){
  is.na(x) | is.null(x) | x == ""
}
