#' GetFunctionIfNamespaced
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' This function looks to see if a strFunction is namespaced and looks it up
#' allowing the do.call in run step to process correctly
#' this will either return a function, or the original string if not namespaced
#'
#' @param strFunction the function to be called
#' @export
#' @examples
#' fn <- GetStrFunctionIfNamespaced("dplyr::glimpse")
#' fn(head(Theoph))
GetStrFunctionIfNamespaced <- function(strFunction) {
  fn_pieces <- strsplit(strFunction, "::")[[1]]
  if (length(fn_pieces) > 2) {
    rlang::abort("function pieces should only be namespaced via <pkg>::<fn>, detected more :: calls")
  }
  if (length(fn_pieces) == 2) {
    pkg <- fn_pieces[[1]]
    fn <- fn_pieces[[2]]
    return(rlang::as_function(fn, env = getNamespace(pkg)))
  }
  return(strFunction)
}
