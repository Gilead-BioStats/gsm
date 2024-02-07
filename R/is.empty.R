#' detect empty spaces in variables
#'
#' @param x
#'
#' @export
#'
is.empty <- function(x){
  is.na(x) | is.null(x) | x == ""
}




